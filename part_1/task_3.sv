//  Генерация рандомной транзакции
//  int     addr - 32-х разрядный адрес
//  int     data - 32-х разрядные данные
//  char    type - тип транзакции 0-READ, 1-WRITE
//  Чтение должно производиться только с тех адресов в которые уже была выполнена запись
module task_3;

    parameter   repeat_n = 100;

    localparam  READ  = '0,
                WRITE = '1;

    typedef struct packed
    {
        integer     n;          // number of transaction
        integer     addr;       // transaction address
        integer     data;       // transaction data
        bit         type_f;     // transaction type
    } tr;   // transaction

    tr      tr_[$];

    initial
    begin
        tr tr_n[$];
        rand_gen_2(repeat_n);
        tr_n = tr_.find(x) with (x.type_f == READ);
        $display("Count of read  transaction = %d (%2.2f%%)", tr_n.size(), tr_n.size() * 100.0 / repeat_n );
        tr_n = tr_.find(x) with (x.type_f == WRITE);
        $display("Count of write transaction = %d (%2.2f%%)", tr_n.size(), tr_n.size() * 100.0 / repeat_n );
        $stop;
    end

    task rand_gen_0(integer rep_n);
        bit         type_f;
        integer     addr;
        integer     data;
        integer     i;
        i = 0;
        repeat( repeat_n )
        begin
            do
            begin
                type_f = $urandom_range(0,1);
                addr = $random();
            end
            while( ( type_f == READ ) ? ! ver_addr(addr, tr_) : '0 );
            data = ( type_f == READ ) ? '0 : $random();
            i++;
            tr_.push_back( { i , addr , data , type_f } );
            print_one_queue_element( tr_[$] );
        end
    endtask : rand_gen_0

    task rand_gen_1(integer rep_n);
        bit         type_f;
        integer     addr;
        integer     data;
        integer     i;
        integer     read_c;
        integer     addr_r;
        read_c = 0;
        i = 0;
        repeat( repeat_n )
        begin
            type_f = WRITE;
            addr = $random();
            if( read_c == 0 )
            begin
                addr_r = addr;
                if( $urandom_range(0,1) == 1 )
                    read_c = $urandom_range(1,2);
            end
            else 
            begin
                read_c--;
                if( read_c == 0 )
                begin
                    type_f = READ;
                    addr = addr_r;
                end
            end
            data = ( type_f == READ ) ? '0 : $random();
            i++;
            tr_.push_back( { i , addr , data , type_f } );
            print_one_queue_element( tr_[$] );
        end
    endtask : rand_gen_1

    task rand_gen_2(integer rep_n);
        bit         type_f;
        integer     addr;
        integer     data;
        integer     i;
        integer     index;
        tr          tr_n [$];
        i = 0;
        // stage_0
        repeat( repeat_n/2 )
        begin
            type_f = WRITE;
            addr = $random();
            data = ( type_f == READ ) ? '0 : $random();
            i++;
            tr_.push_back( { i , addr , data , type_f } );
        end
        // stage_1
        tr_n = tr_;
        do
        begin
            index = $urandom_range(0, tr_.size-1 );
            tr_.insert( index > tr_.size ? tr_.size-1 : index , tr_n.pop_front() );
        end
        while( tr_n.size != 0 );
        // stage_2
        foreach( tr_[i] )
            tr_[i].n = i;
        // stage_3
        foreach( tr_[i] )
        begin
            tr_n = tr_.find_last(x) with ( ( tr_[i].addr == x.addr ) && ( tr_[i].type_f == WRITE ) && ( tr_[i].data == x.data ) );
            if( tr_n.size )
            begin
                index = tr_n[0].n;
                tr_[index] = { index , tr_[i].addr , 0 , READ };
            end
        end
        // print new array
        print_all_queue(tr_);
    endtask : rand_gen_2

    function bit ver_addr(integer addr, tr tr_[$]);
        foreach(tr_[i])
            if( addr == tr_[i] )
                return '1;
        return '0;
    endfunction : ver_addr

    task print_one_queue_element( tr tr_ );
        $display("| %d | %s | 0x%h | 0x%h |", tr_.n, ( tr_.type_f == READ ) ? "READ " : "WRITE" , tr_.addr, tr_.data );
    endtask : print_one_queue_element

    task print_all_queue( tr tr_[$] );
        foreach(tr_[i])
            $display("| %d | %s | 0x%h | 0x%h |", tr_[i].n, ( tr_[i].type_f == READ ) ? "READ " : "WRITE" , tr_[i].addr, tr_[i].data );
    endtask : print_all_queue

endmodule : task_3
