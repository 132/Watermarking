function qr = encode_qr(message, varargin)
% ENCODE_QR create a 2D QR code containing a message
%  
% This function creates a QR code containing a string message. The QR code
% can be of varying sizes.
%
% Note that this function requires zxing (http://code.google.com/p/zxing/)
% installed, and core/core.jar, javase/javase.jar on the classpath
%
% This is the second attempt, based on the code of Lior Shapira, with the
% update to ZXing v. 2.1 codebase and 'parsepropval' for cleaner list of
% the parameters
%   Parameters:
%
%       message - string containing message
%       'Size' - size of the QR code, in pixels. As QR is quadratic, you
%               can supply either scalar or vector. Of you supply vector, 
%               the size must be equal. If the parameter is not supplied.
%               it is determined from 'Version'.
%       'Version', 'v[1..40]' - version of the QR code
%       'Quality', 'L|M|H|Q' - quality of the error correction (Low,
%                           Medium, High, super (not suree ;)
%                           'M' quality is the default
%       'Character_set' - charecter set for encoding QR code. 'UTF-8' is
%                       set to default, other values to be retrieved from 
%       https://github.com/zxing/zxing/blob/master/core/src/com/google/zxing/common/CharacterSetECI.java
%           Using 'Character_set' any other than 'ISO-8859-1' will probably
%           make QR unreadable to any other QR decoder, except ZXing's
%
%   Returns:
%
%       qr - logical matrix of size s containing the QR code
%
%   Example:
%       encode_qr(message, 'Character_set', 'ISO-8859-1')
%       encode_qr(message, 'Size', 25)
%       encode_qr(message, 'Size', [33 33])
%       encode_qr(message, 'Version', 3, 'Quality', 'h', 'Character_set', 'UTF-16BE')
%

%% AUTHOR    : Lior Shapira 
%% $DATE     : 02-Nov-2010 11:20:45 $ 
%% $Revision : 1.00 $ 
%% DEVELOPED : 7.11.0.584 (R2010b) 
%% FILENAME  : encode_qr.m 

import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;


%% parse arguments
% using parsepropval from http://www.mathworks.com/matlabcentral/fileexchange/22671-parse-propertyvalue-pairs-and-structures/content/parsepropval.m
props.size = [ 1 1 ]; % WRONG SIZE. Intentional
props.version = 'v1';
props.quality = 'M';
props.character_set = 'UTF-8';

props = parsepropval(props,varargin{:});
qr_init = 17;   % minimal size of the QR code
qr_delta = 4;   % size of the quiet zone

qr_quality = ['L' 'M' 'Q' 'H']; % error correction quality

% check supplied version
if (isa(props.version,'char') || isa(props.version,'numeric'))
    if isa(props.version,'char')
        qr_ver = str2num(props.version(2:end));
        if not(strcmpi(props.version(1),'v'))
            error('Try removing quotes at "version" parameter value')
        end
    else
        qr_ver = props.version;
    end
else
    error('"version" must be string "v[1..40]" or numerical value [1..40]')
end

if ((qr_ver < 1) || (qr_ver > 40))
    error('"version" must be in [1..40] range')
end

if (props.size(1) == 1)  % matrix size was supplied, don't recalculate
    props.size = qr_init+qr_delta*qr_ver;
end

 % check quality
 if isempty(strfind(qr_quality, upper(props.quality)))
     error('"quality" must be string "L | M | Q | H"')
 else
     switch upper(props.quality)
         case 'M'
             qr_quality = ErrorCorrectionLevel.M;
         case 'L'
             qr_quality = ErrorCorrectionLevel.L;
         case 'H'
             qr_quality = ErrorCorrectionLevel.H;
         case 'Q'
             qr_quality = ErrorCorrectionLevel.Q;
     end
 end

 % check supplied size
if isscalar(props.size)
    props.size = [props.size props.size];
end

 % re-check size
 if (props.size(1) == props.size(2)) % must be equal
    tmp = props.size(1) - 17;
    if not(mod(tmp,4) == 0)
        error('Matrix does not meet sizing requirements (17+N*4)')
    end
else
    error('Matrix must be square')
end


%% encoding qr
qr_writer = QRCodeWriter;
qr_hints = java.util.Hashtable;

% use hint for encoding type
qr_hints.put(EncodeHintType.ERROR_CORRECTION, qr_quality);

% use hint for character set
qr_hints.put(EncodeHintType.CHARACTER_SET, props.character_set);

M_java = qr_writer.encode(message, BarcodeFormat.QR_CODE, props.size(2), props.size(1), qr_hints);
qr = zeros(M_java.getHeight(), M_java.getWidth());
for i=1:M_java.getHeight()
    for j=1:M_java.getWidth()
        qr(i,j) = M_java.get(j-1,i-1);
    end
end

clear qr_writer;
clear M_java;

qr = 1-logical(qr);

% Created with NEWFCN.m by Frank González-Morphy  
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [encode_qr.m] ======  
