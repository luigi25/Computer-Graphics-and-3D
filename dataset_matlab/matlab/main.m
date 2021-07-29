% directory = dir('../3D_regMesh_FRGC_bosph/FRGC_noLm_SLC/');
directory = dir('../3D_regMesh_FRGC_bosph/bosphorus_noLm_SLC/');
files = {directory.name};
count = 0;
len = 0;
% points_bs = 10923; % 1/3 num_points of FRGC_noLm_SLC
points_bs = 9143; % min num_points bosphorus_noLm_SLC
class = strings();
for i = 1:length(files)
    file = char(files(i));
    if contains(file, '.mat')
        count = count + 1;
        % bs = load(string(strcat('../3D_regMesh_FRGC_bosph/FRGC_noLm_SLC/', files(i))));
        bs = load(string(strcat('../3D_regMesh_FRGC_bosph/bosphorus_noLm_SLC/', files(i))));
        modGT = bs.modGT;
        medianX = median(modGT(:,1));
        medianY = median(modGT(:,2));
        medianZ = median(modGT(:,3));
        for index1 = 1:size(modGT)
            temp = modGT(index1, 1);
            temp = temp - medianX;
            modGT(index1, 1) = temp;
            temp = modGT(index1, 2);
            temp = temp - medianY;
            modGT(index1, 2) = temp;
            temp = modGT(index1, 3);
            temp = temp - medianZ;
            modGT(index1, 3) = temp;
        end

        len = len + length(modGT);
        lmidxGT = bs.lmidxGT;
        vect = [modGT(lmidxGT(3), :); modGT(lmidxGT(2), :); modGT(lmidxGT(7), :); modGT(lmidxGT(9), :); modGT(lmidxGT(8), :); modGT(lmidxGT(4), :); modGT(lmidxGT(3), :)];
        
        %{
        clickA3DPoint(modGT', 1, 1);
        disp('eccolo');
        figure
        plot(vect(:, 1),vect(:, 2)) % polygon
        axis equal
        %}
        
        name = erase(file, '.mat');
        land = [];
        
        % plot_landModel(modGT, modGT(land, :), 'r.', 1);          
        
        ptCloudIn = pointCloud(modGT);
        ptCloudOut = pcdownsample(ptCloudIn,'random', points_bs/length(modGT));
        disp(length(ptCloudOut.Location))
        
        in = inpolygon(ptCloudOut.Location(:, 1), ptCloudOut.Location(:, 2), vect(:, 1),vect(:, 2));
        % plot inpolygon
        hold on
        xq = modGT(:, 1);
        yq = modGT(:, 2);
        plot(xq(in),yq(in),'r+') % points inside
        plot(xq(~in),yq(~in),'bo') % points outside
        hold off
        disp(i);
        
        % plot3(ptCloudOut.Location(:,1),ptCloudOut.Location(:,2),ptCloudOut.Location(:,3),'.r');
        
        dataset = [ptCloudOut.Location in];
        
        % writematrix(dataset, ['../3D_regMesh_FRGC_bosph/FRGC_noLm_SLC/dataset/' name], 'delimiter', ' ');
        writematrix(dataset, ['../3D_regMesh_FRGC_bosph/bosphorus_noLm_SLC/dataset/' name], 'delimiter', ' ');
        
        
        disp('ok');
        
        
    end
    % pause(10);
    
end
