function QRS_imputed=impute_QRS_pos(QRS_pos)
QRS_imputed=QRS_pos;

QRS_pos(cellfun(@isempty, QRS_pos)) = {NaN};
QRS_pos=cell2mat(QRS_pos);
med= round(median(QRS_pos,"omitnan"));
QRS_imputed(isnan(QRS_pos)) = {med};

end
