@echo off 
set srcFile=c:\temp.src 
del %srcFile% 
echo open >"%srcFile%" 
echo 192.168.1.31 >>"%srcFile%" 
echo Anonymous >>"%srcFile%" 
echo bin >>"%srcFile%" 
echo put %1 %2_%date%.bak >>"%srcFile%" 
echo quit >>"%srcFile%" 
@echo on 
ftp -s:"%srcFile%"