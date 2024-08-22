function class=get_class_name(name)
if name=='N'
    class='Normal';
elseif name=='A'
    class='Atrial Fibrillation';
elseif name=='O'
    class='Other';
else
    class='Not available';
end
