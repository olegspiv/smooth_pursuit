
which_date = 25032019;
da = 0; % input(' 1 if DA, 0 if no DA ');
la = 0; % input(' 1 if LA, 0 if no LA ');
if da == 0
lum = 1;   %input(' 1 if bright, 0 if dark ');
tar_dim = 0;
elseif da == 1
lum = 0;
tar_dim = 1;    
end
block_num = input ('input block number ');
purs_speed = input('input pursuit speed ');
target_lum = 1; %input ('input target lum ');

%% thresholds

if purs_speed == 3 && da == 1 && tar_dim == 1
    
vel_thres = 20; % degrees per second
down_vel_thres = 4; % degrees per second

%light, 3deg speed

elseif purs_speed == 3 && lum == 1 && tar_dim == 0

vel_thres = 5; % degrees per second
down_vel_thres = 3; % degrees per second

elseif purs_speed == 5 && lum == 1 && tar_dim == 0

vel_thres = 7; % degrees per second
down_vel_thres = 6; % degrees per second
   
elseif  purs_speed == 5 && lum == 0 && tar_dim == 1 && da == 1
    
vel_thres = 20; % degrees per second
down_vel_thres = 5; % degrees per second  

elseif purs_speed == 7 && lum == 1 && tar_dim == 0


vel_thres = 10; % degrees per second
down_vel_thres = 7; % degrees per secon

elseif  purs_speed == 7 && lum == 0 && tar_dim == 1 && da == 1
    
vel_thres = 20; % degrees per second
down_vel_thres = 7; % degrees per second  

elseif purs_speed == 10 && lum == 1 && tar_dim == 0


vel_thres = 15; % degrees per second
down_vel_thres = 10; % degrees per secon

elseif  purs_speed == 10 && lum == 0 && tar_dim == 1 && da == 1

vel_thres = 20; % degrees per second
down_vel_thres = 10; % degrees per second 

elseif purs_speed == 2 && da == 1 && tar_dim == 1
    
    vel_thres = 10; % degrees per second
down_vel_thres = 3; % degrees per second
    
elseif purs_speed == 2 && lum == 1 && tar_dim == 0

     vel_thres = 4; % degrees per second
down_vel_thres = 2; % degrees per second
  
elseif purs_speed == 1 && lum == 1 && tar_dim == 0 
    
     vel_thres = 3; % degrees per second
down_vel_thres = 2; % degrees per second
    

elseif purs_speed == 1 && da == 1 && tar_dim == 1
    
    vel_thres = 10; % degrees per second
down_vel_thres = 4; %2; % degrees per second


end    
%%

factor = 10;

init_fix = 1000;
step = 1;

d = exist('Saccade', 'var');
if d == 1
    j = length(Saccade); 

  trl_num = Saccade(end).trl_num;
  
else trl_num = 0; j = 0;
 
end
clear d


find_false = find(TrialList(:,4)==0);
EyeX(:,find_false) = [];
EyeY(:,find_false) = [];
TargetX(:,find_false) = [];
TargetY(:,find_false) = [];


for index = 1:size(EyeY,2)
    pursuit = 1;
    
[b,a]=butter(2,0.02);


posX = EyeX(:,index);
posY = EyeY(:,index);

posX(isnan(posX)) = [];
posY(isnan(posY)) = [];

posX_filt = filtfilt(b,a,posX);
posY_filt = filtfilt(b,a,posY);

clear posX posY


VelX=savgol3(posX_filt,10,3,1,1000);
VelY=savgol3(posY_filt,10,3,1,1000);
eye_vel=sqrt(VelX.^2+VelY.^2);
Eye_velocity = eye_vel;
Eye_velocity(isnan(Eye_velocity)) = [];


tgt_VelX=savgol3(TargetX(:, index),10,3,1,1000);
tgt_VelY=savgol3(TargetY(:, index),10,3,1,1000);
target_vel=sqrt(tgt_VelX.^2 + tgt_VelY.^2);
Target_velocity = target_vel;
Target_velocity(isnan(Target_velocity)) = [];


    start = step;
    
    trl_num = trl_num+1;
    
    saccade_offset = 0;
    

if TargetX(2000, index) < 0
    side = 0;
else   
    side = 1;      
end
    
    
    if j>0 && j ~= length(Saccade)
    j = j-1;
    disp ('next trial')
% else
% j = 0;
end
    
    
    while saccade_offset+20 < length(Eye_velocity) 
    
         j = j+1;
     
    if saccade_offset>0
        start = saccade_offset;
    end
    
        sooka = Eye_velocity(start:end);

   [saccade_onset, saccade_offset, peak_vel, saccade_duration, saccade_status] = ...
    microsaccade (Eye_velocity, vel_thres, down_vel_thres, sooka, start);
    
d = exist('Saccade', 'var');
if saccade_offset == 0 && d == 0
Saccade(j).status = 0;    
Saccade(j).trl_num = trl_num;
Saccade(j).block_num = block_num;
Saccade(j).date = which_date;
Saccade(j).lum = lum;
Saccade(j).onset = 0;
Saccade(j).offset = 0;
Saccade(j).peak_velocity = 0;
Saccade(j).duration = 0;
Saccade(j).size = 0;
Saccade(j).dark_adapt = da;  
Saccade(j).light_adapt = la;
Saccade(j).tar_dim = tar_dim;
Saccade(j).side = side;
Saccade(j).purs_speed = purs_speed;
Saccade(j).target_lum = target_lum;
Saccade(j).ifblink = 0;
clear d
    break 
elseif saccade_offset == 0
    break
end

  
if saccade_offset >= length(Eye_velocity)
Saccade(j).status = 0;    
Saccade(j).trl_num = trl_num;
Saccade(j).block_num = block_num;
Saccade(j).date = which_date;
Saccade(j).lum = lum;
Saccade(j).onset = 0;
Saccade(j).offset = 0;
Saccade(j).peak_velocity = 0;
Saccade(j).duration = 0;
Saccade(j).size = 0;
Saccade(j).dark_adapt = da;  
Saccade(j).light_adapt = la;
Saccade(j).tar_dim = tar_dim;
Saccade(j).side = side;
Saccade(j).purs_speed = purs_speed;
Saccade(j).target_lum = target_lum;
Saccade(j).ifblink = 0;
    break
end
    
saccade_size = sqrt((posX_filt(saccade_offset)-posX_filt(saccade_onset))^2 ...
    + (posY_filt(saccade_offset)-posY_filt(saccade_onset))^2);
if saccade_size<0
    saccade_size = saccade_size*(-1);
end


Saccade(j).status = 1; 
Saccade(j).trl_num = trl_num;
Saccade(j).block_num = block_num;
Saccade(j).date = which_date;
Saccade(j).lum = lum;
Saccade(j).onset = saccade_onset;
Saccade(j).offset = saccade_offset;
Saccade(j).peak_velocity = peak_vel;
Saccade(j).duration = saccade_duration;
Saccade(j).size = saccade_size;
Saccade(j).dark_adapt = da;  
Saccade(j).light_adapt = la;
Saccade(j).tar_dim = tar_dim;
Saccade(j).side = side;
Saccade(j).purs_speed = purs_speed;
Saccade(j).target_lum = target_lum;    
Saccade(j).ifblink = 0;

   clear sooka saccade_onset peak_vel saccade_duration saccade_size start 
   
    end 
    
    subplot(2,1,1)

plot(posY_filt)
hold on
plot(posX_filt, 'r');
plot(TargetX(:,index), 'y')
title(['trial ' num2str(index)])
yL = get(gca,'YLim');


 line([step step],yL,'Color','b');
 line([init_fix init_fix] ,yL,'Color','b');


 p = exist('Saccade', 'var');
 
if p == 1
    
for i = 1:length(Saccade)
    
    if Saccade(i).trl_num == trl_num && Saccade(i).offset ~=0
        
line([Saccade(i).onset Saccade(i).onset],yL,'Color','g');
line([Saccade(i).offset Saccade(i).offset],yL,'Color','g');
    end
end
end
 grid on

 subplot(2,1,2)
 
 Eye_velocity (isnan(Eye_velocity)) = [];
 
 plot(Eye_velocity)
 
 ylim([0 60])
 
 yL = get(gca,'YLim');

 line([step step],yL,'Color','b');
 line([init_fix init_fix] ,yL,'Color','b');
 
 if p == 1
    
for i = 1:length(Saccade)
    
    if Saccade(i).trl_num == trl_num && Saccade(i).offset ~=0
        
line([Saccade(i).onset Saccade(i).onset],yL,'Color','g');
line([Saccade(i).offset Saccade(i).offset],yL,'Color','g');
    end
end
 end

  %% loop 
    
   while 1

b = input('next (1) remove(0) add (2) mark blink (3) remove by click (4) add by click (5) remove blink (6) '); % add the possbility to discard the trial


if b == 6
    
      disp('please select blink to remove, right click to exit')
    
      while 1
          
[x,y, button] = ginput(1);

 no_blink = round(x(1));
       
    for i = 1:length(Saccade)
     
 if Saccade(i).trl_num == trl_num 
 
 
 if no_blink > Saccade(i).onset && no_blink < Saccade(i).offset
     
     
Saccade(i).ifblink = 0;

line([Saccade(i).onset Saccade(i).onset] ,yL,'Color','g');
line([Saccade(i).offset Saccade(i).offset] ,yL,'Color','g');
 
 end
 end
    end  
     
 
    
 if button == 3
   break 
  end
      end     
    
      
elseif b == 3
    
        disp('please select blink to add, right click to exit')
     
  while 1
         
 [x,y, button] = ginput(1);

 blink = round(x(1));
  
 for i = 1:length(Saccade)
     
 if Saccade(i).trl_num == trl_num 
 
 
 if blink > Saccade(i).onset && blink < Saccade(i).offset
     
     
Saccade(i).ifblink = 1;

line([Saccade(i).onset Saccade(i).onset] ,yL,'Color','r');
line([Saccade(i).offset Saccade(i).offset] ,yL,'Color','r');
 
 end
 end
 end
 
 if button == 3
   break 
 end
  end



elseif b == 4 
    
    while 1
    disp('please select the saccade to remove')
    
[x,y, button] = ginput(1);
      
 badsac = round(x(1));    

for i = 1:length(Saccade)
    
 if Saccade(i).trl_num == trl_num 
     
     if badsac > Saccade(i).onset && badsac < Saccade(i).offset

Saccade(i).status = 0;    
Saccade(i).onset = 0;
Saccade(i).offset = 0;
Saccade(i).peak_velocity = 0;
Saccade(i).duration = 0;
Saccade(i).size = 0;  
        
      end
    end
end

clear x y

clf    
       

subplot (2,1,1)
plot(posY_filt)
title(['trial ' num2str(index)])
hold on
plot(posX_filt, 'r');
yL = get(gca,'YLim');

    
for i = 1:length(Saccade)
    
    if Saccade(i).trl_num == trl_num && Saccade(i).offset ~=0
        
line([Saccade(i).onset Saccade(i).onset],yL,'Color','g');
line([Saccade(i).offset Saccade(i).offset],yL,'Color','g');
    end
end

 grid on       
  
         subplot (2,1,2)

      plot(Eye_velocity)
       ylim([0 60])
      yL = get(gca,'YLim');

  for i = 1:length(Saccade)
    
    if Saccade(i).trl_num == trl_num && Saccade(i).offset ~=0
        
line([Saccade(i).onset Saccade(i).onset],yL,'Color','g');
line([Saccade(i).offset Saccade(i).offset],yL,'Color','g');
    end
  end



if button == 3
   break 
end

    end 
  

elseif b == 5
        
disp('please select saccades to add, right click to exit')
   

while 1
         
 [x,y, button] = ginput(1);

 goodsac = round(x(1));    

 clear i

 if goodsac > 1 && goodsac < length(posY_filt)
     
     
for i = goodsac:length(Eye_velocity)
    
    if i+3 <=length(Eye_velocity) && Eye_velocity(i) <= down_vel_thres && Eye_velocity(i+1) <= down_vel_thres ...
           && Eye_velocity(i+2) <= down_vel_thres &&  Eye_velocity(i+3) <= down_vel_thres
        
        saccade_offset = i;
        
        break
        
    end
end


delta = i - goodsac;


 clear i

vector = Eye_velocity(1:goodsac);
vector_inv = vector(end:-1:1);

for i = 1:length(vector_inv)
    
 vector_2(i) = vector_inv(i);  
 
if vector_inv(i)<=down_vel_thres && vector_inv(i+1)<=down_vel_thres && vector_inv(i+2)<=down_vel_thres && ...
        vector_inv(i+3)<=down_vel_thres
    
    break
end
end

saccade_onset = saccade_offset-i-delta;

clear i delta vector_2 vector vector_inv

peakvel = max(Eye_velocity(saccade_onset:saccade_offset));
saccade_duration = saccade_offset-saccade_onset;

disp(['saccade onset is ' num2str(saccade_onset) ' ms'])
disp(['saccade offset is ' num2str(saccade_offset) ' ms'])
disp(['peak velocity is ' num2str(peak_vel) ' deg/sec'])
disp(['saccade duration is ' num2str(saccade_duration) ' ms'])
           

saccade_size = sqrt((posX_filt(saccade_offset)-posX_filt(saccade_onset))^2 ...
    + (posY_filt(saccade_offset)-posY_filt(saccade_onset))^2);
if saccade_size<0
    saccade_size = saccade_size*(-1);
end


disp(['saccade size is ' num2str(saccade_size) ' deg'])


if saccade_duration > 1  
    
  o = length(Saccade)+1;

Saccade(o).status = 1; 
Saccade(o).trl_num = trl_num;
Saccade(o).block_num = block_num;
Saccade(o).date = which_date;
Saccade(o).lum = lum;
Saccade(o).onset = saccade_onset;
Saccade(o).offset = saccade_offset;
Saccade(o).peak_velocity = peak_vel;
Saccade(o).duration = saccade_duration;
Saccade(o).size = saccade_size;
Saccade(o).dark_adapt = da;  
Saccade(o).light_adapt = la;
Saccade(o).tar_dim = tar_dim;
Saccade(o).side = side;
Saccade(o).purs_speed = purs_speed;
Saccade(o).target_lum = target_lum;  
Saccade(o).ifblink = 0;   
end

clear t o

clf
    
  subplot (2,1,1)
plot(posY_filt)
title(['trial ' num2str(index)])
hold on
plot(posX_filt, 'r');
yL = get(gca,'YLim');

    
for i = 1:length(Saccade)
    
    if Saccade(i).trl_num == trl_num && Saccade(i).offset ~=0
        
line([Saccade(i).onset Saccade(i).onset],yL,'Color','g');
line([Saccade(i).offset Saccade(i).offset],yL,'Color','g');
    end
end

 grid on       
  
         subplot (2,1,2)

      plot(Eye_velocity)
       ylim([0 60])
      yL = get(gca,'YLim');

  for i = 1:length(Saccade)
    
    if Saccade(i).trl_num == trl_num && Saccade(i).offset ~=0
        
line([Saccade(i).onset Saccade(i).onset],yL,'Color','g');
line([Saccade(i).offset Saccade(i).offset],yL,'Color','g');
    end
  end
  
 end 
  
  

if button == 3
   break 
end

end 


elseif b == 0
    
    c = input('which saccade is to be deleted? ');
    
       for i = 1:length(Saccade)
        
        if Saccade(i).trl_num == trl_num 
                
Saccade(i+c-1).status = 0;     
Saccade(i+c-1).trl_num = trl_num;
Saccade(i+c-1).block_num = block_num;
Saccade(i+c-1).date = which_date;
Saccade(i+c-1).lum = lum;
Saccade(i+c-1).onset = 0;
Saccade(i+c-1).offset = 0;
Saccade(i+c-1).peak_velocity = 0;
Saccade(i+c-1).duration = 0;
Saccade(i+c-1).size = 0;
Saccade(i+c-1).dark_adapt = da;  
Saccade(i+c-1).light_adapt = la;
Saccade(i+c-1).tar_dim = tar_dim;
Saccade(i+c-1).side = side;
Saccade(i+c-1).purs_speed = purs_speed;
Saccade(i+c-1).target_lum = target_lum;
Saccade(i+c-1).ifblink = 0;
    break        
        end    
        end         
         
        clf       

        subplot (2,1,1)
plot(posY_filt)
title(['trial ' num2str(index)])
hold on
plot(posX_filt, 'r');
yL = get(gca,'YLim');

    
for i = 1:length(Saccade)
    
    if Saccade(i).trl_num == trl_num && Saccade(i).offset ~=0
        
line([Saccade(i).onset Saccade(i).onset],yL,'Color','g');
line([Saccade(i).offset Saccade(i).offset],yL,'Color','g');
    end
end

 grid on       
  
         subplot (2,1,2)

      plot(Eye_velocity)
       ylim([0 60])
      yL = get(gca,'YLim');

  for i = 1:length(Saccade)
    
    if Saccade(i).trl_num == trl_num && Saccade(i).offset ~=0
        
line([Saccade(i).onset Saccade(i).onset],yL,'Color','g');
line([Saccade(i).offset Saccade(i).offset],yL,'Color','g');
    end
  end

  
  elseif b == 2
      
       while 1
          c = input ('change vel thres? (1 - change, 2 - make lower, 0 - no change) ');
          
          if c == 1
      vel_thres2 = input ('what is the vel thres? ');
      down_vel_thres2 = input('what is the down vel thres? ');
      break
      
          elseif c == 2
           vel_thres2 = 20;
           down_vel_thres2 = 5;
           break
           
          elseif c==0
            vel_thres2 = vel_thres;
            down_vel_thres2 = down_vel_thres;            
              break 
          end
      end
    
    [x,y] = ginput(2);
      
      st = round(x(1));
      fin = round(x(2)); 

      clear x y
    

       while 1
     if fin<=st
         disp ('mistake!')
         [x,y] = ginput(1); 
         disp('input the correct end of time interval (ms) ')
     fin = round(x(1));     
      
     else
         sooka = Eye_velocity(st:fin);
break
     end
       end 
       
  [saccade_onset, saccade_offset, peak_vel, saccade_duration, saccade_status] = ...
    microsaccade_diff_thres (Eye_velocity, vel_thres2, down_vel_thres2, sooka, st);
 
%%%%%%%%%%%%%%%%%%%%%%%  
        
if saccade_onset == 0
    disp('no saccade')
% break 
    
else
 
disp(['saccade onset is ' num2str(saccade_onset) ' ms'])
disp(['saccade offset is ' num2str(saccade_offset) ' ms'])
disp(['peak velocity is ' num2str(peak_vel) ' deg/sec'])
disp(['saccade duration is ' num2str(saccade_duration) ' ms'])
       
line([saccade_onset saccade_onset],yL,'Color','g');
line([saccade_offset saccade_offset],yL,'Color','g');

saccade_size = sqrt((posX_filt(saccade_offset)-posX_filt(saccade_onset))^2 ...
    + (posY_filt(saccade_offset)-posY_filt(saccade_onset))^2);
if saccade_size<0
    saccade_size = saccade_size*(-1);
end


disp(['saccade size is ' num2str(saccade_size) ' deg'])
      
      
while 1
    disp('zufrieden?')
    t = input ('good (1) no good (0) ');
    
    if t == 1
        
o = length(Saccade)+1;

Saccade(o).status = 1; 
Saccade(o).trl_num = trl_num;
Saccade(o).block_num = block_num;
Saccade(o).date = which_date;
Saccade(o).lum = lum;
Saccade(o).onset = saccade_onset;
Saccade(o).offset = saccade_offset;
Saccade(o).peak_velocity = peak_vel;
Saccade(o).duration = saccade_duration;
Saccade(o).size = saccade_size;
Saccade(o).dark_adapt = da;  
Saccade(o).light_adapt = la;
Saccade(o).tar_dim = tar_dim;
Saccade(o).side = side;
Saccade(o).purs_speed = purs_speed;
Saccade(o).target_lum = target_lum;
Saccade(o).ifblink = 0;

    break

    elseif t == 0
        
        break
    end
end
end
clear vel_thres2 down_vel_thres2 t o    


elseif b == 1
     
  
  v = 999;
  while v~=0 && v~=1
      
    v = input ('good (1) or bad(0)? ');
    
  if v == 1
      if_trl_good = 1;
  elseif v == 0
      if_trl_good = 0;
  end
  end
  clf
  
    break

end

clear saccade_offset A 

   end

disp ('fuh')
   
%% sort offsets and onsets

% correct for the next trials on Saccade

trl = Saccade(end).trl_num;

for d = length(Saccade):-1:1
    
    if Saccade(d).trl_num ~= trl
        
        break
    end
end
 
where = d+1;

if if_trl_good

    p = 0;
for i = where:length(Saccade)
    
    p = p+1;
    
    onset(p) = Saccade(i).onset;
%     onset(p,2) = Saccade(i).trl_num;
    
    offset(p) = Saccade(i).offset;
%     offset(p,2) = Saccade(i).trl_num;
    
%     trl(i) = Saccade(i).trl_num; 
    
end

clear i d p 

on = sort(onset);
off = sort(offset);

on (on == 0) = [];
off(off == 0) = [];

%% ktaim 

if ~isempty (on)


% find relevant intervals of initial fixation

if on(1) <= init_fix
    
     ktaim_fix(1).eye_vel = Eye_velocity(step:on(1)-factor);
     ktaim_fix(1).target_vel = Target_velocity(step:on(1)-factor);
     
     ktaim_fix(1).eyeX = posX_filt (step:on(1)-factor);
     ktaim_fix(1).eyeY = posY_filt (step:on(1)-factor);
  

p = 0;

  for i = 1:length(on)

    if  i+1 <= length (on) && on(i+1) <= init_fix 
     
    p = p+1;
    
    ktaim_fix(p+1).eye_vel = Eye_velocity(off(i)+factor:on(i+1)-factor);
    ktaim_fix(p+1).target_vel = Target_velocity(off(i)+factor:on(i+1)-factor);
%     
    ktaim_fix(p+1).eyeX = posX_filt(off(i)+factor:on(i+1)-factor);
    ktaim_fix(p+1).eyeY = posY_filt(off(i)+factor:on(i+1)-factor);
%     
    
    else
        break
    
 end
  end   
  
   ktaim_fix(length(ktaim_fix)+1).eye_vel = Eye_velocity(off(i)+factor:init_fix);
   ktaim_fix(length(ktaim_fix)).target_vel = Target_velocity(off(i)+factor:init_fix);
%    
   ktaim_fix(length(ktaim_fix)).eyeX = posX_filt(off(i)+factor:init_fix);
   ktaim_fix(length(ktaim_fix)).eyeY = posY_filt(off(i)+factor:init_fix);

  clear i
  
else
    
    ktaim_fix(1).eye_vel = Eye_velocity(step:init_fix);
    ktaim_fix(1).target_vel = Target_velocity(step:init_fix);
    
    ktaim_fix(1).eyeX = posX_filt(step:init_fix);
    ktaim_fix(1).eyeY = posY_filt(step:init_fix);
  
end
  
% find relevant intervals of supposed pursuit time


    for i = 1:length(on)
        
        if on(i)>init_fix
            
  ktaim_purs(1).eye_vel = Eye_velocity(init_fix:on(i)-factor);
  ktaim_purs(1).target_vel = Target_velocity(init_fix:on(i)-factor);  
  ktaim_purs(1).eyeX = posX_filt(init_fix:on(i)-factor);  
  ktaim_purs(1).eyeY = posY_filt(init_fix:on(i)-factor);  
  
  break
        end
    end

    
    if exist ('ktaim_purs')
                
p = 0;

for i = 1:length(on)
    if i+1 <= length (on) && on(i)>= init_fix
        
        p = p+1;
            
   ktaim_purs(p+1).eye_vel = Eye_velocity(off(i)+factor:on(i+1)-factor);
   ktaim_purs(p+1).target_vel = Target_velocity(off(i)+factor:on(i+1)-factor);
   ktaim_purs(p+1).eyeX = posX_filt(off(i)+factor:on(i+1)-factor);
   ktaim_purs(p+1).eyeY = posY_filt(off(i)+factor:on(i+1)-factor);
   
    end
end
clear i

ktaim_purs(length(ktaim_purs)+1).eye_vel = Eye_velocity(off(end)+factor:length(Eye_velocity));
ktaim_purs(length(ktaim_purs)).target_vel = Target_velocity(off(end)+factor:length(Target_velocity));
ktaim_purs(length(ktaim_purs)).eyeX = posX_filt(off(end)+factor:length(Target_velocity));
ktaim_purs(length(ktaim_purs)).eyeY = posY_filt(off(end)+factor:length(Target_velocity));

    else 
        
  ktaim_purs(1).eye_vel = Eye_velocity(init_fix:end);
  ktaim_purs(1).target_vel = Target_velocity(init_fix:end);
  ktaim_purs(1).eyeX = posX_filt(init_fix:end);
  ktaim_purs(1).eyeY = posY_filt(init_fix:end);
  
end

  
else

      ktaim_purs(1).eye_vel = Eye_velocity(init_fix:end);
      ktaim_purs(1).target_vel = Target_velocity(init_fix:end);
      ktaim_purs(1).eyeX = posX_filt(init_fix:end);
      ktaim_purs(1).eyeY = posY_filt(init_fix:end);

           
      ktaim_fix(1).eye_vel = Eye_velocity(step:init_fix);
      ktaim_fix(1).target_vel = Target_velocity(step:init_fix);
      ktaim_fix(1).eyeX = posX_filt(step:init_fix);
      ktaim_fix(1).eyeY = posY_filt(step:init_fix);
     
end

%% concatenate purs and fix vectors clear from saccades

purs_vector_vel(1:length(ktaim_purs(1).eye_vel)) = ktaim_purs(1).eye_vel;

if length(ktaim_purs)>1
for i = 2:length(ktaim_purs)

      purs_vector_vel (length(purs_vector_vel)+1:length(purs_vector_vel)+length(ktaim_purs(i).eye_vel)) = ktaim_purs(i).eye_vel;
         
end

end 
clear i


fix_vector_vel(1:length(ktaim_fix(1).eye_vel)) = ktaim_fix(1).eye_vel;
if length(ktaim_fix)>1
    
for i = 2:length(ktaim_fix)

     fix_vector_vel (length(fix_vector_vel)+1:length(fix_vector_vel)+length(ktaim_fix(i).eye_vel)) = ktaim_fix(i).eye_vel;
         
end
end

clear i



purs_vector_eyeX(1:length(ktaim_purs(1).eyeX)) = ktaim_purs(1).eyeX;

if length(ktaim_purs)>1
for i = 2:length(ktaim_purs)
   
    purs_vector_eyeX (length(purs_vector_eyeX)+1:length(purs_vector_eyeX)+length(ktaim_purs(i).eyeX)) = ktaim_purs(i).eyeX;
         
      
end

end 
clear i


purs_vector_eyeX_conc(1:length(ktaim_purs(1).eyeX)) = ktaim_purs(1).eyeX;

if length(ktaim_purs)>1
    
for i = 2:length(ktaim_purs)
    
if ~isempty (ktaim_purs(i).eyeX) 
    
    if i > 2
       
     if ~isempty (purs_vector_eyeX_conc)
         differ =  ktaim_purs(i).eyeX(1) - purs_vector_eyeX_conc(end);
     else
         differ =  ktaim_purs(i).eyeX(1);
     end
  
        
       
    else
    
  if ~isempty(ktaim_purs(i-1).eyeX)
         differ = ktaim_purs(i).eyeX(1) - ktaim_purs(i-1).eyeX(end); 
  else
         differ = ktaim_purs(i).eyeX(1); 
  end
  
    end
    
    
  q = ktaim_purs(i).eyeX - differ;   
    
  purs_vector_eyeX_conc (length(purs_vector_eyeX_conc)+1:length(purs_vector_eyeX_conc)+length(ktaim_purs(i).eyeX)) = q;
  
end    
      
clear q differ

end


end 
clear i


purs_vector_eyeY(1:length(ktaim_purs(1).eyeY)) = ktaim_purs(1).eyeY;

if length(ktaim_purs)>1
for i = 2:length(ktaim_purs)

      purs_vector_eyeY (length(purs_vector_eyeY)+1:length(purs_vector_eyeY)+length(ktaim_purs(i).eyeY)) = ktaim_purs(i).eyeY;
         
end

end 
clear i


fix_vector_eyeX(1:length(ktaim_fix(1).eyeX)) = ktaim_fix(1).eyeX;

if length(ktaim_fix)>1
for i = 2:length(ktaim_fix)

      fix_vector_eyeX (length(fix_vector_eyeX)+1:length(fix_vector_eyeX)+length(ktaim_fix(i).eyeX)) = ktaim_fix(i).eyeX;
         
end

end 
clear i


fix_vector_eyeY(1:length(ktaim_fix(1).eyeY)) = ktaim_fix(1).eyeY;

if length(ktaim_fix)>1
for i = 2:length(ktaim_fix)

      fix_vector_eyeY (length(fix_vector_eyeY)+1:length(fix_vector_eyeY)+length(ktaim_fix(i).eyeY)) = ktaim_fix(i).eyeY;
         
end

end 
clear i

differ =  purs_vector_eyeX_conc(1)-fix_vector_eyeX(end);       % ktaim_purs(i).eyeX(1) - purs_vector_eyeX_conc(end);
purs_vector_eyeX_conc = purs_vector_eyeX_conc-differ;

oleg = [fix_vector_eyeX purs_vector_eyeX_conc];

clear differ
%% estimate pursuit onset

while 1
    
% seg1 (during Fixation)

plot (oleg)
yL = get(gca,'YLim');
hold on
line ([length(fix_vector_eyeX) length(fix_vector_eyeX)], yL, 'color', 'b')

disp('choose fix interval')

[c,d] = ginput(2);

x1=(round(c(1)):round(c(2)))'; 
y1=oleg(x1)';

if purs_speed == 7 || purs_speed == 10
x11=(1:2000)';
else 
 x11=(1:5000)';
end
    

[B1,~,~,~,~]=regress(y1,[ones(size(x1)) x1]);
FIT1= B1(2)*x11+B1(1);

clear c d

% Seg2 (during pursuit)

disp('choose pursuit interval')

[c,d] = ginput(2);

x2= (round(c(1)):round(c(2)))';
y2= oleg(x2)';
if purs_speed == 7 || purs_speed == 10
x22=(1:2000)';

else 
    
  x22=(1:5000)';
end

clear c d

[B2,~,~,~,~]=regress(y2,[ones(size(x2)) x2]);
FIT2= B2(2)*x22+B2(1);

temp=nan(size(FIT2));
temp(1:size(FIT1))=FIT1;

Difference=abs(FIT2-temp);
Estimate1=find(Difference==min(Difference));

plot(x11,FIT1,'Color',[1 0.5 0],'Linestyle','--','LineWidth',1);
plot(x22,FIT2,'Color',[0 1 0],'Linestyle','--','LineWidth',1);

if Estimate1 <= length(oleg)
    
plot(Estimate1,oleg(Estimate1),'ok')

else
    
    disp ('bad estimate')
    
end

pause

% correct the estimate for the original vector with saccades in between

for i = 1:length(on)   
    if Estimate1 > on(i)
        k = i;
  Estimate1 = Estimate1+(off(i)-on(i)) + factor*2;
  
    end
end

% check if there is a saccadic onset within 100 ms from the estimated purs onset.
% if there is saccadic onset found, purs onset will be defined at the
% offset of this saccade

if exist ('k') && k+1 <= length(on)
    
if Estimate1 + 100 > on(k+1)
    Estimate1 = off(k+1);
end
    clear i k
end
    
clf

    subplot (2,1,1)
plot (posX_filt, 'r')
hold on
plot(posY_filt, 'b')
yL = get(gca,'YLim');
line ([init_fix init_fix], yL, 'color', 'b')
line ([Estimate1 Estimate1], yL, 'color', 'r')


         subplot (2,1,2)

      plot(Eye_velocity)
       ylim([0 60])
      yL = get(gca,'YLim');
 line ([init_fix init_fix], yL, 'color', 'b')
line ([Estimate1 Estimate1], yL, 'color', 'r')     
      

disp ('is everything allright?')

b = input ('correct (0) continue (1) input (2) or no pursuit (3) ? ');

if b == 0
    
    clf
    
    clear Estimate1 x11 x22 FIT1 FIT2 Difference temp B2 B1 y2 x2 y1 x1
    
    continue

    
elseif b == 2
 
    g = 0;
    
while g ~= 1 
    
clf

    subplot (2,1,1)

plot (posX_filt, 'r')
hold on
plot(posY_filt, 'b')
yL = get(gca,'YLim');
line ([init_fix init_fix], yL, 'color', 'b')


         subplot (2,1,2)
      plot(Eye_velocity)
       ylim([0 60])
      yL = get(gca,'YLim');
 line ([init_fix init_fix], yL, 'color', 'b')

disp('where did the pursuit start?')

[c,d] = ginput(1);

Estimate1 = round(c);
clear c d

line ([Estimate1 Estimate1], yL, 'color', 'r')


disp ('is everything allright?')

g = input ('correct (0) or continue (1)?  ');

end

    if g == 1
        clf
        break
    end
    
elseif b == 1
    
    clf
    break



elseif b == 3
    
%    if_trl_good = 0;
   pursuit = 0;
   clf
   break
end

end
    
 clear x11 x22 FIT1 FIT2 Difference temp B2 B1 y2 x2 y1 x1 g

 %% gain calculation

if pursuit == 1
    
diff_corr_to_onset = Estimate1 - init_fix;


d = 0;
s = 0;
while d < diff_corr_to_onset && s+1 <= length(ktaim_purs)
    
    s = s+1;
       
    d = d + length(ktaim_purs(s).eyeX);

end

purs_onset = diff_corr_to_onset;

if s > 1
    
    
    for i = 1:s-1
        
    purs_onset =  purs_onset - length(ktaim_purs(i).eyeX);
    
    end
    clear i
    
    m = 0;
    for i = s:length (ktaim_purs)
        
   if ~isempty (ktaim_purs(i).eyeX)
        
        if i == s     
            
    m = m+1;

gain(m,1) = mean(ktaim_purs(i).eye_vel(purs_onset:end))./mean(ktaim_purs(i).target_vel(purs_onset:end)); 
gain(m,2) = length(ktaim_purs(i).eye_vel(purs_onset:end));
        else
            
            m = m+1;
gain(m,1) =  mean(ktaim_purs(i).eye_vel) ./ mean(ktaim_purs(i).target_vel);    
gain(m,2) = length(ktaim_purs(i).eye_vel);
        end
       
   end
    end
    
    clear i
    
else
              
   m = 0; 
  for i = 1:length(ktaim_purs)
    
      if ~isempty (ktaim_purs(i).eyeX)
      
    if i == 1
      m = m+1;  
gain(m,1) = mean(ktaim_purs(i).eye_vel(purs_onset:end))./mean(ktaim_purs(i).target_vel(purs_onset:end)); 
gain(m,2) = length(ktaim_purs(i).eye_vel(purs_onset:end));
    else
           m = m+1;  
gain(m,1) = mean(ktaim_purs(i).eye_vel)./mean(ktaim_purs(i).target_vel); 
   gain(m,2) = length(ktaim_purs(i).eye_vel);

    end
  end
  end           
end
    


  mean_gain = mean(gain(:,1));
  
  for i = 1:size(gain,1)  
 gain(i,3) = gain(i,1)*gain(i,2);
  end
  
  twag_ms = mean(gain(:,3));
  twag_s = twag_ms/1000;
  
else 
 mean_gain = 0;
 
 twag_s = 0;
end
  
  
  pursuit_onset = Estimate1;

 if where == 2
    
     for i = 1:length(Saccade)
  Saccade(i).purs_onset = pursuit_onset;
  Saccade(i).gain = mean_gain;
  Saccade(i).twag = twag_s;
  Saccade(i).target_onset = init_fix;
  Saccade(i).if_trl_good = if_trl_good;
  Saccade(i).pursuit = pursuit;
     end
     
 else
     
    for i = where:length(Saccade)
  Saccade(i).purs_onset = pursuit_onset;
  Saccade(i).gain = mean_gain;
  Saccade(i).twag = twag_s;
  Saccade(i).target_onset = init_fix; 
  Saccade(i).if_trl_good = if_trl_good;
  Saccade(i).pursuit = pursuit;

    end
 end

 
else 
    
     for i = where:length(Saccade)
  Saccade(i).purs_onset = 0;
  Saccade(i).gain = 0;
  Saccade(i).twag = 0;
  Saccade(i).target_onset = 0; 
  Saccade(i).if_trl_good = if_trl_good;   
  Saccade(i).pursuit = pursuit;
  
     end
end

 clear i ktaim_fix ktaim_purs a b eye_vel Eye_velocity fix_vector_eyeX fix_vector_eyeY ...
     fix_vector_vel gain m off on onset offset oleg posX_filt posY_filt purs_onset pursuit_onset...
     purs_vector_eyeX_conc purs_vector_eyeX purs_vector_eyeY purs_vector_vel s ...
     sooka start target_vel Target_velocity tgt_VelX tgt_VelY trl VelY VelX peak_vel p if_trl_good v

 
    end

% clear

    clearvars -except Saccade j 
    
    save('Saccade', 'Saccade')

    close all