using Match
using Formatting


hex2bits(hex::Char)= @match hex begin
    '0' => "0000"
    '1' => "0001"
    '2' => "0010"
    '3' => "0011"
    '4' => "0100"
    '5' => "0101"
    '6' => "0110"
    '7' => "0111"
    '8' => "1000"
    '9' => "1001"
    'A' => "1010"
    'B' => "1011"
    'C' => "1100"
    'D' => "1101"
    'E' => "1110"
    'F' => "1111"
end

function hex2bits(hex::String)
    return join(map(hex2bits, collect(hex)))
end

function getPacketVersion(bits::String)
    return parse(Int, bits[1:3], base=2)
end

function getPacketTypeId(bits::String)
    return parse(Int, bits[4:6], base=2)
end

function getPacketLengthTypeId(bits::String)
    @match bits[7] begin
        '0' => 15
        '1' => 11
    end
end



struct ParsedPacket 
    version::Int
    typeId::Int
    literal::Int
    children::Array{ParsedPacket}
end

function parseLiteral(bits)
    finished = false
    i = 1
    numberbits = ""
    rem = ""
    while !finished
        finished = bits[i] == '0' 
        numberbits *= bits[i+1:i+4]
        rem = bits[i+5:end]
        i+=5
    end

    return parse(Int, numberbits; base=2), rem
end

function parseString(bits::String)
    packetVersion = getPacketVersion(bits)
    packetTypeId = getPacketTypeId(bits)
    if all(collect(bits).=='0')
        return nothing, ""
    end
   
    if packetTypeId == 4
        value, rem = parseLiteral(bits[7:end])
        children = []
    else
        value = 0
        children, rem = getOperatorChildren(bits[7:end])
    end
    return ParsedPacket(packetVersion, packetTypeId, value, children), rem
end

function getOperatorChildren(bits::String)

    if bits[1] == '0'
        subPacketLength = parse(Int, bits[2:16]; base=2)
        remainingBits = bits[17:end]
        subPackets = []
        bitsToRemain = length(bits) - subPacketLength - 16
        while length(remainingBits) > bitsToRemain
            currentPacket, remainingBits = parseString(remainingBits)
            push!(subPackets, currentPacket)
        end
        return subPackets, remainingBits
    else
        numSubPackets = parse(Int, bits[2:12]; base=2)
        subPackets = []
        remainingBits = bits[13:end]
        while length(subPackets) < numSubPackets
            currentPacket, remainingBits = parseString(remainingBits)
            push!(subPackets, currentPacket)
        end
        return subPackets, remainingBits
    end
end

function versionSum(packet::ParsedPacket)
    childrenSum = length(packet.children) > 0 ? sum([versionSum(c) for c in packet.children]) : 0
    return packet.version + childrenSum
end

function evaluatePacket(packet::ParsedPacket)
    childValues = [evaluatePacket(c) for c in packet.children]
    result = @match packet.typeId begin
        0 => sum(childValues)
        1 => prod(childValues)
        2 => minimum(childValues)
        3 => maximum(childValues)
        4 => packet.literal
        5 => childValues[1] > childValues[2] ? 1 : 0
        6 => childValues[1] < childValues[2] ? 1 : 0
        7 => childValues[1] == childValues[2] ? 1 : 0

    end
    return result
end
    

test_packets = [ "D2FE28",
"38006F45291200", 
"620080001611562C8802118E34", 
"C0015000016115A2E0802F182340",
"A0016C880162017C3686B18A3D4780"]

for b in test_packets
    bits = hex2bits(b)
    packet, rem = parseString(bits)
    printfmt("\npacket {} versionSum: {}", b, versionSum(packet))
end

f = open(joinpath(@__DIR__, "../input/day16.txt"));
b = readline(f)
bits = hex2bits(b)
packet, rem = parseString(bits)
printfmt("\npacket {} \nversionSum: {}\n evaluated: {}", b, versionSum(packet), evaluatePacket(packet))


# test_strings = [
# "C200B40A82",
# "04005AC33890",
# "880086C3E88112",
# "CE00C43D881120",
# "D8005AC2A8F0",
# "F600BC2D8F",
# "9C005AC2F8F0",
# "9C0141080250320F1802104A08"
# ]

# for b in test_strings 
#     test_bits = hex2bits(b)
#     p, r = parseString(test_bits)
#     printfmt("\npacket {} evaluated: {}", b, evaluatePacket(p))
# end
