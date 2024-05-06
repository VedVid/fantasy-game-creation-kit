--[[
The MIT License (MIT)

Copyright (c) 2016 losttoken

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

string.ulen = function(str)
    local _, count = string.gsub(str, "[^\128-\193]", "")
    return count
end

string.ulist=function(str)
    local list={}
    for uchar in string.gfind(str, '[%z\1-\127\194-\244][\128-\191]*') do list[#list+1] = uchar end
    return list
end

string.usub = function(str,i,j)
    local list=string.ulist(str)
    local substr=""
    if j==nil then j=#list end
	if i==0 then i=1 end
	if j==0 then j=1 end
	i=i>0 and i or #list+i+1
	j=j>0 and j or #list+j+1
	if i>j then i=i+j;j=i-j;i=i-j; end	
    for k=i,j,1 do
        if list[k]~=nil then
            substr=substr..list[k]
        end
    end
    return substr
end

string.ufind=function(str,pattern)
    local b,e=string.find(str,pattern)
    if b==nil then return nil end
    local list=string.ulist(str)
    local count=1
    local beginPos=0
    local endPos=0
    for k,v in ipairs(list) do
        if b==count then
            beginPos=k
        end
        if e==count-1 then
            endPos=k-1
            return beginPos,endPos
        end
        count=count+string.len(v)
    end
    if e==count-1 then
        endPos=#list
        return beginPos,endPos
    end
    return nil,nil
end

string.ucharAt=function(str,pos)
	local list=string.ulist(str)
    pos=pos>0 and pos or #list+pos+1
    return string.ulist(str)[pos]
end

string.ureverse=function(str)
    local list=string.utable(str)
    local reverseList=""
    for k,v in ipairs(list) do
        reverseList=v..reverseList
    end
    return reverseList
end