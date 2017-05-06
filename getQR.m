function [messageB,messageF]=getQR()
    javaaddpath('.\core.jar');
    javaaddpath('.\javase.jar');
    % decode
    vidF = videoinput('winvideo', 1, 'YUY2_640x480');
    vidB = videoinput('winvideo', 2, 'YUY2_640x480');
    srcF = getselectedsource(vidF);
    srcB = getselectedsource(vidB);
    messageB = [];
    messageF = [];

    vidF.ReturnedColorspace = 'rgb';
    vidF.FramesPerTrigger = 1;
    vidB.ReturnedColorspace = 'rgb';
    vidB.FramesPerTrigger = 1;
    disp('Reading QR codes...');
    while isempty(messageB) || isempty(messageF)
        start(vidB);
        start(vidF);
        curB = decode_qr(getdata(vidB));
        curF = decode_qr(getdata(vidF));
        if ~isempty(curB)
            messageB = curB;
        end
        if ~isempty(curF)
            messageF = curF;
        end
    end
    disp('QR Codes:');
    disp(messageB)
    disp(messageF);
    delete(vidB);
    delete(vidF);
end