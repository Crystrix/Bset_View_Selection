function result = read(fname, format)
if strcmp('off', format)
    result = Off2Patch(fname);
else if strcmp('ply', format)
        result = read_ply(fname);
    end
end
