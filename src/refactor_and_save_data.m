function data=refactor_and_save_data(original_data_path)
n_el=numel(dir(original_data_path+"\MAP_A"))-2;
    for i = 1:n_el
        for map_name=["A","B","C"] %indifferent, effective, dangerous
            % Loading Subject
            MAP=readtable(original_data_path+"\MAP_"+map_name+"\MAP_"+map_name+num2str(i)+".csv");

            % Refactoring Subject
            MAP=maps_refactoring(MAP,processed_data_path+'\MAP_'+map_name+'\MAP_'+map_name+num2str(i)+'_refactored.csv');

            % Adding data to a struct
            main_field='MAP_'+map_name;
            sub_field='MAP_'+map_name+num2str(i);
            data.(main_field).(sub_field)=MAP;
        end
    end
    save("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed\dataset.mat",'data')
    
end
