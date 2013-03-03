function Out = Off2Patch(fname)
%
% OFF2PATCH Load the .off file into a patch structure
% 
% This function load a .off formatted file (from Princeton 3D Object
% Library) into a patch structure which matlab can handle, for example, the 
% 3D objects represented by .off file can be visualized in matlab.
% The format of .off file can go to reference on Princeton website.
%

try
    fid = fopen(fname);

    % read the first line, which is 'off'
    header = fgetl(fid);
    if ~strcmp(upper(header),'OFF'),
        disp('Warning, wrong format, however, we will go on')
    end;

    % read the the dimension (VxFxE)
    dimension = str2num(fgetl(fid));

    % read the vertices
    vertices = -ones(dimension(1),3);
    for I=1:dimension(1),
        vertices(I,:) = str2num(fgetl(fid));
    end;

    % read the faces, here only faced with 4 vertices are allowed
    faces = -ones(dimension(2),3);
    for J=1:dimension(2),
        face = str2num(fgetl(fid));
        if length(face(2:end)) > size(faces,2),
            faces = [faces -ones(size(faces,1),length(face)-1-size(faces,2))];
        end
        faces(J,:) = face(2:end)+1;
    end;

    faces(faces==-1)=NaN;
    
    % close the file handle and return
    fclose(fid);

    Out.dimension = dimension;
    Out.vertices = vertices;
    Out.faces = faces;
    
catch
    Out = [];
    disp('Something bad happened.');
end
