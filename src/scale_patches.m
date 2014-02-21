% 
% Scale maintaining the foot location (y_max of the last patch)
% i.e. the central point will be changed!
% 
% USAGE
%   target = scale_patches(target, scale)
%
function tracker = scale_patches(tracker, scale)


for i = 1:size(tracker.patches,2);
    roi = tracker.patches(i).roi;   
     
    %% initializes variables
    min_x = roi(1,1); max_x = roi(1,2);
    min_y = roi(2,1); max_y = roi(2,2);
    cx = (max_x + min_x)/2;
    cy = (max_y + min_y)/2;
    
    %% compute the new x coordinates
    w     = max_x - min_x;
    new_w = scale*w;
    hw = new_w/2;
    
    min_x = cx - hw;
    max_x = cx + hw;
    
    %% y coordinates
    h     = max_y - min_y;
    new_h = scale*h;    
    min_y = max_y - new_h;
    % max_y = cx + hw;
    
    %% change the patch for good
    roi = [min_x, max_x; min_y max_y];
    tracker.patches(i).roi = roi;
            
end

%% update the width of the whole tracker
tracker.w = new_w;

%% now removes the gaps between the patches
for i=size(tracker.patches,2)-1:-1:1
    %% initialize
    roi      = tracker.patches(i).roi;   
    next_roi = tracker.patches(i+1).roi;
    
    min_y = roi(2,1); max_y = roi(2,2);
    n_min_y = next_roi(2,1);
    
    % what I need to deslocate is the difference between my max_y and min_y
    % of the next frame
    dy = n_min_y - max_y;
    min_y = min_y + dy;
    max_y = max_y + dy;
    
    tracker.patches(i).roi(2,1) = min_y;
    tracker.patches(i).roi(2,2) = max_y;
end
