BUS_WR=0b11
BUS_RD=0b01

def to_4bytes int
  (0..3).map{|i| (int >> i*8) & 0xff}
end

def from_4bytes bytes
  bytes.map.with_index{|e,i| (e << i*8)}.sum
end

number_1 = nil
while number_1.nil?
  puts "Please enter a floating point number: "
  user_input = gets.chomp

  begin
    number_1 = Float(user_input)
  rescue ArgumentError
    puts "Invalid input. Please enter a valid floating point number."
  end
end
bytes = [number_1].pack("f").bytes
ieee_754_number_1 = "0x#{bytes.reverse.map { |b| b.to_s(16).rjust(2, '0') }.join}"
puts "The floating number #{number_1} in IEEE 754 32-bit representation is : #{ieee_754_number_1}"

number_2 = nil
while number_2.nil?
  puts "Please enter a floating point number: "
  user_input = gets.chomp

  begin
    number_2 = Float(user_input)
  rescue ArgumentError
    puts "Invalid input. Please enter a valid floating point number."
  end
end
bytes = [number_2].pack("f").bytes
ieee_754_number_2 = "0x#{bytes.reverse.map { |b| b.to_s(16).rjust(2, '0') }.join}"
puts "The floating number #{number_1} in IEEE 754 32-bit representation is : #{ieee_754_number_2}"

command = nil
while command.nil?
  puts "Please enter an operation (+, -, *, /): "
  operation = gets.chomp
  case operation
  when "+"
    command = 0x00000001
    puts "Operation is : #{number_1} + #{number_2}"
  when "-"
    command = 0x00000003
    puts "Operation is : #{number_1} - #{number_2}"
  when "*"
    command = 0x00000005
    puts "Operation is : #{number_1} * #{number_2}"
  when "/"
    command = 0x00000007
    puts "Operation is : #{number_1} / #{number_2}"
  else
    puts "Invalid operation, please enter a valid operation."
  end
end

transactions=[
  [BUS_WR, 0x00000001,ieee_754_number_1.hex],
  [BUS_WR, 0x00000002,ieee_754_number_2.hex],
  [BUS_WR, 0x00000000,command],
  [BUS_RD, 0x00000003,0x00000000],
]

require 'uart'
uart = UART.open '/dev/ttyUSB1', 19200, '8N1'

ieee754_result = 0
transactions.each do |cmd,addr,data|
  if cmd==BUS_WR
    puts "write 0x%08x,   0x%08x" % [addr,data]
    uart.write [BUS_WR].pack 'C'
    uart.write to_4bytes(addr).pack 'C*'
    uart.write to_4bytes(data).pack 'C*'
  else
    print "read  0x%08x -> " % [addr]
    uart.write [BUS_RD].pack 'C'
    uart.write to_4bytes(addr).pack 'C*'
    bytes=[]
    while bytes.size !=4
      byte=uart.read(1)
      bytes << byte.unpack('C') if byte
    end
    bytes.flatten!
    ieee754_result=from_4bytes(bytes)
    puts "0x%08x" % [ieee754_result]
  end
end

float_value = [ieee754_result].pack('N').unpack('g')[0]  # conversion en flottant
puts " test value : #{float_value}"

case command
	when 1
		puts " expected value : #{number_1 + number_2}"
	when 3
		puts " expected value : #{number_1 - number_2}"
	when 5
		puts " expected value : #{number_1 * number_2}"
	when 7
		puts " expected value : #{number_1 / number_2}"
end


