function sample(filename, format, iteration_number)
    model = read(filename, format);
    %info_file = fopen([filename(1:length(filename)-length(format)-1), '_info.txt']); 
    %info = textscan(info_file,'%s%s',1);

    %fclose(info_file);
    %model.vertices = [model.vertices(:,1),model.vertices(:,3),model.vertices(:,2)];
    
    [signals,PC,V] = pca1(model.vertices');
    model.vertices = signals';
    
    value = max(model.vertices);
    max_x = value(1);
    max_y = value(2);
    max_z = value(3);
    value = min(model.vertices);
    min_x = value(1);
    min_y = value(2);
    min_z = value(3);
    center_x = (max_x + min_x)/2;
    center_y = (max_y + min_y)/2;
    center_z = (max_z + min_z)/2;
    coeff = 1.1;
    radius = sqrt(((max_x - min_x)/2)^2 + ((max_y - min_y)/2)^2 + ((max_z - min_z)/2)^2);
    
    model.vertices(:, 1) = model.vertices(:, 1) - center_x;
    model.vertices(:, 2) = model.vertices(:, 2) - center_y;
    model.vertices(:, 3) = model.vertices(:, 3) - center_z;

    
    [vertices, faces] = platonic_solid(4, radius*coeff);
    %vertices(:, 1) = vertices(:, 1) + center_x;
    %vertices(:, 2) = vertices(:, 2) + center_y;
    %vertices(:, 3) = vertices(:, 3) + center_z;
    tempVertices = vertices';
    tempFaces = faces';
    
    for m = 1:iteration_number
        [tempVertices, tempFaces] = loopSubdivision(tempVertices, tempFaces);
    %[tempVertices, tempFaces] = loopSubdivision(tempVertices, tempFaces);
    end
    
    tempVertices = tempVertices';
    %tempFaces = tempFaces';
    max_x_difference = max_x - min_x;
    max_y_difference = max_y - min_y;
    max_z_difference = max_z - min_z;

    

    if(max_x_difference <= max_y_difference)
        if(max_x_difference <= max_z_difference)
            if(max_y_difference > max_z_difference)
                model.vertices = [model.vertices(:,1),model.vertices(:,3),model.vertices(:,2)];
            end
            %view([1,0,0]);
        else
            model.vertices = [model.vertices(:,3),model.vertices(:,1),model.vertices(:,2)];
            %view([0,0,1]);
            %view([1,0,0]);
        end
    else
        if(max_y_difference <= max_z_difference)
            if(max_x_difference <= max_z_difference)
                model.vertices = [model.vertices(:,2),model.vertices(:,1),model.vertices(:,3)];
                %view([1,0,0]);
            else
                model.vertices = [model.vertices(:,2),model.vertices(:,3),model.vertices(:,1)];
                %view([1,0,0]);
            end
            %view([0,1,0]);
        else
            model.vertices = [model.vertices(:,3),model.vertices(:,2),model.vertices(:,1)];
            %view([1,0,0]);    
            %view([0,0,1]);
        end            
    end
    
	figure;
	set(gcf, 'Renderer', 'opengl');
    graph = patch('faces',model.faces, 'vertices',model.vertices);
    set(graph,'FaceAlpha',1);
    view([1,0,0]);
    
    set(gca,'LooseInset',get(gca,'TightInset'))
    axis off;
    axis tight;
    axis equal;
    %axis vis3d;
    for m = 1:size(tempVertices,1);
        view(tempVertices(m, :));
        %saveas(graph,['./',num2str(iteration_number), '/sample_',filename,'_',num2str(tempVertices(m, :)),'.bmp']);
        depthData=mexGetDepth;
		%saveas(graph,[ 'sample_',filename,'_',num2str(tempVertices(m, :)),'.bmp']);
		saveas(depthData,[ 'sample_',filename,'_',num2str(tempVertices(m, :)),'.bmp']);
    end
    cla reset;
    close;
end

