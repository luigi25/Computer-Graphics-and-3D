directory = dir('../3D_regMesh_FRGC_bosph/FRGC_noLm_SLC/');
% directory = dir('../3D_regMesh_FRGC_bosph/bosphorus_noLm_SLC/');
files = {directory.name};
count = 0;
len = 0;
points_bs = 6704; % modFinal
class = strings();
for i = 1:length(files)
    file = char(files(i));
    if contains(file, '.mat')
        count = count + 1;
        bs = load(string(strcat('../3D_regMesh_FRGC_bosph/FRGC_noLm_SLC/', files(i))));
        % bs = load(string(strcat('../3D_regMesh_FRGC_bosph/bosphorus_noLm_SLC/', files(i))));
        modFinal = bs.modFinal;
        len = len + length(modFinal);
        vect = [modFinal(2652, :); modFinal(2468, :); modFinal(2421, :); modFinal(2417, :); modFinal(617, :); modFinal(660, :); modFinal(6042, :); modFinal(2081, :); modFinal(1947, :); modFinal(2213, :); modFinal(3712, :); modFinal(4104, :); modFinal(5993, :); modFinal(2349, :); modFinal(2540, :); modFinal(2652, :)];
        % clickA3DPoint(modFinal', 1, 1);
        
        %{
        if strcmp(file, '04839d176.mat') == 1  || strcmp(file, '04839d178.mat') == 1 || strcmp(file, '04839d180.mat') == 1
            plot_landModel(modGT, modGT(lmidxGT, :), 'r.', 1);
            disp('ok');
        end
        %}
        
        name = erase(file, '.mat');
        land = [];
        
        % plot_landModel(modGT, modGT(land, :), 'r.', 1);       
        
        in = inpolygon(modFinal(:, 1), modFinal(:, 2), vect(:, 1),vect(:, 2));
        disp(i);
        
        %{
        if strcmp(file, '04202d452.mat') == 1
            hold on
            xq = modFinal(:, 1);
            yq = modFinal(:, 2);
            plot(xq(in),yq(in),'ro') % points inside
            plot(xq(~in),yq(~in),'bo') % points outside
            hold off
            disp('ok')
        end
        %}
        
        
        dataset = [modFinal in];
        
        writematrix(dataset, ['../3D_regMesh_FRGC_bosph/FRGC_noLm_SLC/dataset_modFinal/' name], 'delimiter', ' ');
        
        % writematrix(dataset, ['../3D_regMesh_FRGC_bosph/bosphorus_noLm_SLC/dataset_modFinal/' name], 'delimiter', ' ');
        
        disp('ok');
        
        
    end
    % pause(10);
    
end
