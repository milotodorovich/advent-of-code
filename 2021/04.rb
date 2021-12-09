inputFile = File.readlines(ARGV[0], chomp: true)

# inputFile.each { |x| puts x }

boardsCount = 0
inputFile = File.readlines(ARGV[0], chomp: true)
inputs = inputFile.shift.split(",").map(&:to_i)

puts inputs

class Element

    def initialize(value)
        @value = value
        @covered = false
    end

    def cover(input)
        @covered = true if @value == input
    end

    def covered?
        @covered
    end

    def value
        @value
    end

    def to_s
        "Element value=#{@value} covered=#{@covered}"
    end

end

class Board 

    def initialize(*rows)
        @elements = []
        rows.each_with_index do |row, i|
            rowData = row.split(" ").map(&:to_i)
            @elements << rowData.map { |i| Element.new(i)}
        end
        puts "-"*15
    end

    def play(n) 
        @elements.each do |row|
            row.each do |e|
                e.cover(n)
            end
        end
    end

    def winner?
        rowWinner = @elements.map do |row|
            row.all?(&:covered?)
        end.any? { |x| x==true }

        colWinner = (0..4).to_a.each do |i|
            @elements.map { |row| row[i] }.all?(&:covered?)
        end.any?  { |x| x==true }

        return rowWinner || colWinner
    end

    def uncoveredElements
        @elements.flatten.flatten.select{ |x| !x.covered? }
    end

    def to_s
        "Board: @elements=#{@elements} winner?=#{winner?}"
    end
end

inputFile = inputFile.select { |x| x.length > 0 }

puts "Board rows: #{inputFile.size}"

boards = []
while inputFile.length > 0
    boards << Board.new(inputFile.shift, inputFile.shift, inputFile.shift, inputFile.shift, inputFile.shift)
end

puts boards.size
# boards.each { |b| puts b}

# while inputs.size > 0
#     n = inputs.shift
#     # puts n

#     boards.each { |b| b.play(n) }
#     # pp boards
#     # puts boards.map(&:winner?)

#     if boards.any?(&:winner?) 
#         puts "FIRST WINNER!"
#         pp winner = boards.select(&:winner?).first
#         puts sum = winner.uncoveredElements.map(&:value).sum
#         puts "Number: #{n}"
#         puts "Result: #{n*sum}"
#         break
#     end

# end

# inputFile = File.readlines(ARGV[0], chomp: true)
# inputs = inputFile.shift.split(",").map(&:to_i)

# boards = []
# while inputFile.length > 0
#     boards << Board.new(inputFile.shift, inputFile.shift, inputFile.shift, inputFile.shift, inputFile.shift)
# end
lastWinner = nil

while inputs.size > 0
    n = inputs.shift

    boards.each { |b| b.play(n) }

    if boards.select { |b| !b.winner? }.size == 1
        lastWinner = boards.select { |b| !b.winner? }.last
        puts "LAST WINNER BOARD!"
        pp lastWinner
    end

    if boards.all?(&:winner?) 
        puts "LAST WINNER!"
        # pp winner = boards.select(&:winner?).first
        puts sum = lastWinner.uncoveredElements.map(&:value).sum
        puts "Number: #{n}"
        puts "Result: #{n*sum}"
        break
    end

end