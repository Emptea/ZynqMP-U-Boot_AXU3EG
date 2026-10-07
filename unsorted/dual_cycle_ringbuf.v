// ---------------------------------------------------------------------------
// dual_cycle_ringbuf
//
// Модуль с двумя циклами работы и кольцевым буфером.
//
//  Цикл 1 (запись):
//      По сигналу готовности wr_valid входная шина wr_data пишется в кольцевой
//      буфер. Буфер хранит (N+K) посылок, каждая посылка — последовательность
//      из M слов, т.е. глубина буфера DEPTH = (N+K)*M слов. Указатель записи
//      заворачивается по модулю DEPTH.
//
//  Цикл 2 (чтение, по сигналу start):
//      Для каждой позиции current_pos выдаются по очереди (с out_valid)
//      элементы по адресам:
//          current_pos, current_pos + M, current_pos + 2M, ...,
//          current_pos + 2*M*N                        (всего 2N+1 отсчётов)
//      Адрес чтения заворачивается по модулю DEPTH (кольцевой буфер).
//      Затем current_pos сдвигается на 1 и всё повторяется — и так M раз
//      (current_pos = 0 .. M-1). После этого автомат возвращается в цикл 1
//      («на исходную») и выдаёт импульс done.
//
//  Параметры: M, N, K и ширина данных WIDTH.
// ---------------------------------------------------------------------------
module dual_cycle_ringbuf #(
    parameter integer WIDTH = 16,   // ширина шины данных
    parameter integer M     = 4,    // длина последовательности (посылки)
    parameter integer N     = 3,    // параметр выборки (число шагов 2N+1)
    parameter integer K     = 2     // запас глубины буфера (посылок сверх N)
)(
    input  wire             clk,
    input  wire             rst_n,      // асинхронный сброс, активный низкий

    // --- цикл 1: запись ---
    input  wire             wr_valid,   // готовность входных данных
    input  wire [WIDTH-1:0] wr_data,    // входная шина данных

    // --- управление ---
    input  wire             start,      // запуск второго цикла (импульс)

    // --- цикл 2: чтение/выдача ---
    output reg              out_valid,  // готовность выходных данных
    output reg  [WIDTH-1:0] out_data,   // выходная шина данных
    output reg              busy,       // идёт цикл чтения
    output reg              done        // импульс по завершении цикла чтения
);

    // -----------------------------------------------------------------------
    // Производные параметры
    // -----------------------------------------------------------------------
    localparam integer DEPTH = (N + K) * M;                       // глубина буфера, слов
    localparam integer AW    = (DEPTH <= 1) ? 1 : $clog2(DEPTH);  // ширина адреса
    localparam integer IW    = (N == 0)     ? 1 : $clog2(2*N+1)+1;// счётчик 0..2N
    localparam integer PW    = (M <= 1)     ? 1 : $clog2(M);      // позиция 0..M-1

    // -----------------------------------------------------------------------
    // Память кольцевого буфера (синхронное чтение -> инференс BRAM)
    // -----------------------------------------------------------------------
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // -----------------------------------------------------------------------
    // Регистры состояния
    // -----------------------------------------------------------------------
    localparam ST_WRITE = 1'b0;
    localparam ST_READ  = 1'b1;
    reg state;

    reg [AW-1:0] wp;            // указатель записи
    reg [PW-1:0] current_pos;   // внешний цикл: 0..M-1
    reg [IW-1:0] inner_i;       // внутренний цикл: 0..2N
    reg [AW-1:0] rd_addr;       // текущий адрес чтения

    // Следующий адрес чтения = rd_addr + M, по модулю DEPTH (кольцо).
    // Так как rd_addr < DEPTH и M <= DEPTH, достаточно одного вычитания.
    wire [AW:0]   rd_addr_sum  = {1'b0, rd_addr} + M;
    wire [AW-1:0] rd_addr_wrap = (rd_addr_sum >= DEPTH) ?
                                 (rd_addr_sum - DEPTH) : rd_addr_sum[AW-1:0];

    // -----------------------------------------------------------------------
    // Автомат
    // -----------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= ST_WRITE;
            wp          <= {AW{1'b0}};
            current_pos <= {PW{1'b0}};
            inner_i     <= {IW{1'b0}};
            rd_addr     <= {AW{1'b0}};
            out_valid   <= 1'b0;
            out_data    <= {WIDTH{1'b0}};
            busy        <= 1'b0;
            done        <= 1'b0;
        end else begin
            out_valid <= 1'b0;   // по умолчанию: нет выдачи
            done      <= 1'b0;   // импульс на один такт

            case (state)

            // ---------- Цикл 1: запись в кольцевой буфер ----------
            ST_WRITE: begin
                busy <= 1'b0;
                if (wr_valid) begin
                    mem[wp] <= wr_data;
                    wp <= (wp == DEPTH-1) ? {AW{1'b0}} : (wp + 1'b1);
                end
                if (start) begin
                    state       <= ST_READ;
                    busy        <= 1'b1;
                    current_pos <= {PW{1'b0}};
                    inner_i     <= {IW{1'b0}};
                    rd_addr     <= {AW{1'b0}};   // база = current_pos = 0
                end
            end

            // ---------- Цикл 2: чтение/выдача ----------
            ST_READ: begin
                busy <= 1'b1;

                // выдача текущего отсчёта (синхронное чтение памяти)
                out_valid <= 1'b1;
                out_data  <= mem[rd_addr];

                if (inner_i == 2*N) begin
                    // внутренний цикл для данной позиции завершён
                    inner_i <= {IW{1'b0}};
                    if (current_pos == M-1) begin
                        // все M позиций пройдены -> возврат на исходную
                        state <= ST_WRITE;
                        busy  <= 1'b0;
                        done  <= 1'b1;
                    end else begin
                        current_pos <= current_pos + 1'b1;
                        rd_addr     <= current_pos + 1'b1; // новая база
                    end
                end else begin
                    // следующий шаг: +M с заворотом
                    inner_i <= inner_i + 1'b1;
                    rd_addr <= rd_addr_wrap;
                end
            end

            endcase
        end
    end

endmodule
