errorcheck='false';
%First part of the code
sampleFreq= input(sprintf('enter Fs:')); %input fs
while(sampleFreq <= 0) %check validity of Fs
    disp('erorr!!!!');
    sampleFreq=input(sprintf('enter correct Fs:'));
end 

%second part of the code
start= input(sprintf('enter start time:')); %input starting time
endTime= input(sprintf('enter ending time:')); %input ending time
while(endTime <= start) %check validity of time range
    disp('error!!!!');
    endTime= input(sprintf('enter ending time:')); 
end

%third part of the code
t=start:1/sampleFreq:endTime;
BpointsNum= input(sprintf('enter numbers of BREAKPOINTS:')); %input no. Breakpoints
while(BpointsNum < 0) %checl validity of breakpoints number
    disp('error!!!!!!');
    BpointsNum= input(sprintf('enter numbers of BREAKPOINTS:')); 
end
position=[start zeros(1,BpointsNum)];
signal = zeros(size(t));
for i=1:BpointsNum
    position(i+1)=input('Enter breakpoints position:');
end
position(end+1)=endTime;

for j=1:length(position)-1    
    if strcmp(errorcheck,'false')                                       % error check to exit if it was True
        signal_type=input('Enter your signal type 1)dc 2)ramp 3)exponent 4)sinosoidal 5)polynomial :'); % asking user for signal type
         t2=position(j):1/sampleFreq:(position(j+1)-1/sampleFreq);  % t2 contains time range of the current breakpoint only 

%fourth part of choosing the signals
                switch signal_type
                 
                    case 1 %Dc
                        amplitude=input('Enter the Amplitude:');                                             
                        signal(t>=position(j) & t<position(j+1))=amplitude;   % signal generation
                        
                        
                    case 2 %ramp
                        slope=input('Enter your signal slope:');                                             
                        intercept=input('Enter your signal intercept:');
                        signal(t>=position(j) & t<position(j+1))=slope*t2+intercept;  % signal generation
                        
                        
                    case 3 %exponential
                        e_amplitude=input('Enter your signal amplitude:');                                   
                        exponent=input('Enter your signal exponent:');
                        signal(t>=position(j) & t<position(j+1))=e_amplitude*exp(t2*exponent); % signal generation
                        
                        
                    case 4 %sinosoidal
                        s_amplitude=input('Enter your signal amplitude:');                                   
                        frequancy=input('Enter your signal frequncy:');
                        phase=input('Enter your signal phase:');
                        signal(t>=position(j) & t<position(j+1))=sin(2*pi*frequancy*t2+phase)*s_amplitude;   % signal generation
                        
                        
                    case 5 %polynomial
                        powerp=input('Enter your power:');                                                   
                        intercept=input('Enter your intercept:');
                        amplitude=[];    % coefficients vector
                        
                        for h=1:powerp  % getting coefficients
                           amplitude(end+1)=input('Enter amplitude:');
                        end
                        
                        for i=1:length(t)  % signal generation
                           if (t(i)>=position(j)&&t(i)<position(j+1))
                                for k=1:powerp
                                     signal(i)=signal(i)+amplitude(k)*(t(i)^k);
                                end
                           end
                           signal(i)=signal(i)+intercept;
                        end
                       
                    otherwise
                        disp('signal cant be generated')
                        errorcheck='True';
                end  
        end
    
end

if strcmp(errorcheck,'false')
    f1=figure; 
    plot(t,signal);
    title('original signal');
end

%fifth part of code doing operattion on signal
operation=input('choose operation to perform on signal 1)scaling 2)shifting 3)compression 4)expanding 5)reverse 0)exit: '); 

while(1)
    
    switch operation
        
        case 1 %scaling
            t2=t;  % new time range
            scaling=input('enter scaling factor ');                         
            signal2 = scaling.*signal;  % generating new signal
            xxx='s';

        case 2 %shifting
            shift=input('enter shift value '); 
            xxx='sh';
            t2=t; % new time range
            if shift >= 0     % generating new signal for shifting left
                  for i=1:length(t)
                    if (i+(shift*sampleFreq))<=length(t)
                         signal2(i)=signal(i+(shift*sampleFreq));
                    else 
                        signal2(i)=0;
                    end 
                  end
            else    % generating new signal for shifting right
                for i=1:length(t)
                    if (i+(shift*sampleFreq))>0
                         signal2(i)=signal(i+(shift*sampleFreq));
                    else 
                        signal2(i)=0;
                    end 
                  end
            end
                    
        case 3 %compression
            comp=input('enter compression factor ');                       
            t2= start/comp : 1/sampleFreq : endTime/comp ;  % new time range
            signal2=resample(signal,1,comp);  % generating new signal
            xxx='c';
             
        case 4 %expanding
            expand=input('enter expansion factor ');                         
            t2= start*expand : 1/sampleFreq : (endTime*expand)+1/sampleFreq ; % new time range
            signal2=resample(signal,expand,1);  % generating new signal 
            xxx='e';
        case 5 %reversing
            xxx='rev';
            t2=-1*t;
            signal2=signal;
        case 0
            break;
                 
        otherwise 
            errorcheck='True';
            disp('unknown operation')
            break;
    end
     if strcmp(errorcheck,'false')  % check error
        if strcmp(xxx,'s')
            f2=figure;     % plotting signal
            plot(t2,signal2);
            title('scaled signal');
        end
        if strcmp(xxx,'sh')
                f2=figure;    % plotting signal
                plot(t2,signal2);
                title('shifted signal');
        end
        if strcmp(xxx,'c')
                f2=figure;     % plotting signal
                plot(t2,signal2);
                title('compressed signal');
        end
        if strcmp(xxx,'e')
                f2=figure;   % plotting signal
                plot(t2,signal2);
                title('expanding signal');
        end
        if strcmp(xxx,'rev')
            f2=figure;
            plot(t2,signal2);
            title('signal reversed');
        end
     end
     %asking for operation again
    operation=input('choose operation to perform on signal 1)scaling 2)shifting 3)compression 4)expanding 0)exit: '); 
end