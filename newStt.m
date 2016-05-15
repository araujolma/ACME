function [SttInfo] = newStt(SttInfo,newInitStt,newSttName)
%newStt Sets a new state.
%   Updates 

NStt = SttInfo.NStt + 1;

SttInfo.NStt = NStt;
SttInfo.InitSttArry = [SttInfo.InitSttArry; newInitStt];
SttInfo.SttIndx.(newSttName) = NStt;
SttInfo.SttNameArry{NStt} = newSttName;

end

