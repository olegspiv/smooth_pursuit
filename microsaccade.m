function [saccade_onset, saccade_offset, peak_vel, saccade_duration, saccade_status] = ...
    microsaccade (Eye_velocity, vel_thres, down_vel_thres, sooka, start)


for index = 1:length(sooka)
    
 vector(index) = sooka(index);
 
if  vector(index)>= vel_thres 

break 
end
end
  clear index  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if length(vector) == length(sooka)
    
    saccade_status = 0;
    saccade_onset = 0;
    saccade_offset = 0;
    peak_vel = 0;
    saccade_duration = 0;
else
  
    saccade_status = 1;
vector_inv = vector(end:-1:1);

for index = 1:length(vector_inv)
 vector_2(index) = vector_inv(index);  
 
if vector_2(index)<=down_vel_thres 

    break
end
end

clear index

if  exist('old_saccade_offset') ~= 0
saccade_onset = old_saccade_offset + length(vector)-length(vector_2); %+100;
else 
    
    
 saccade_onset = start + length(vector)-length(vector_2); %+100   
% saccade_onset = light_off+500 + length(vector)-length(vector_2); %+100;


end


if saccade_onset == start
    saccade_onset = saccade_onset+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
b = sooka(length(vector):end);

for i = 1:length(b)
    
    vect(i) = b(i);
    
    if length(b)>3 && i < length(b)-3
        
    if vect(i) <= down_vel_thres ... 
    && b(i+1)<=down_vel_thres && b(i+2)<=down_vel_thres ...
        && b(i+3)<=down_vel_thres 
        
        break
              
    end 
    
    else
     if vect(i) <= down_vel_thres
         break         
     end
    end
end

saccade_offset = start + length(vector) + length(vect);

if saccade_offset > length(Eye_velocity)
    peak_vel  = max(Eye_velocity(saccade_onset:end));
else
peak_vel = max(Eye_velocity(saccade_onset:saccade_offset));
end
saccade_duration = saccade_offset-saccade_onset;

end

