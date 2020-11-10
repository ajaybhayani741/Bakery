def get_rules(code,total_number)
    @arr = [ {
        code: 'VS5',
        packs: [ {count: 3, cost: 6.99},
                  {count: 5, cost: 8.99} ]
      },
      {
        code: 'MB11',
        packs: [ { count: 2, cost: 9.95 },
          { count: 5, cost: 16.95 },
          { count: 8, cost: 24.95 } ]
      },
      {
        code: 'CF',
        packs: [ { count: 3, cost: 5.95 },
          { count: 5, cost: 9.95 },
          { count: 9, cost: 16.99 } ]
      },
    ]

    packs = @arr.find {|item| item[:code] == code }[:packs].sort_by{|e| -e[:count]}

    total = 0 
    @final_items = []
    packs.each do |item| 
      @final_items = []
      current_count = item[:count] 

      if (total_number % current_count == 0) 
        # @final_items << { item: item, collect: (total_number / current_count) }
        (total_number / current_count).times { @final_items << item }

        total = total_number
        break 
      elsif 
        return_int = total_number / current_count 
        # puts "-----0------#{return_int}---#{}" 

        return_int.times do |i| 
          # puts "-----0.01------#{i}" 
          @final_items = []

          total = current_count * (return_int-i) 
          (return_int-i).times { @final_items << item }
          # @final_items = [{ item: item, collect: ((return_int-i)) }]

          puts "-----1------#{total}" 
          packs.each do |pack| 
            next if pack == item 

            tt = 1 
            loop do 
             if total >= total_number 
              # puts "-----2.1---#{pack[:count]}---#{tt}--#{total}" 
              if total == total_number
                break
              else
                total = total - (pack[:count]) if tt > 1
              end
              puts "-----2.2-----#{total_number}---#{total}" 
              break 
             else 
              total += pack[:count]   
              @final_items << pack if total <= total_number 
              tt += 1 
              puts "-----2------#{total}" 
             end 
            end 
            break if total == total_number
          end 

          break if total == total_number

        end 

      end 

      break if total == total_number

    end
    @final_items = @final_items.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }
    puts "-----> #{@final_items.inspect}"
  end

  get_rules('MB11',16)