function newData= align_and_filter_dataset(original_data,sub_align_data,filter,RP,Fc)
% data should have inside the FB found previously

newData=original_data;
map_names=["MAP_A","MAP_B","MAP_C"];
n_sub=length(fieldnames(newData.MAP_A.MAP_A1));

for i=1:3
    map=map_names(i);
    for j= 12 % 1:n_sub
        sub=map+num2str(j);
        for k=1:width(newData.(map).(sub).rov_trace)
            % Extraction of signals
            rov=original_data.(map).(sub).rov_trace{:,k};
            ref=original_data.(map).(sub).ref_trace{:,k};
            spare1=original_data.(map).(sub).spare1_trace{:,k};
            spare2=original_data.(map).(sub).spare2_trace{:,k};
            spare3=original_data.(map).(sub).spare3_trace{:,k};

            if filter
                % DWT Filter application
                newData.(map).(sub).rov_trace{:,k}=denoise_ecg_wavelet(rov-mean(rov), Fs, 'sym4',9);
                newData.(map).(sub).ref_trace{:,k}=denoise_ecg_wavelet(ref-mean(ref), Fs, 'sym4',9);
                newData.(map).(sub).spare1_trace{:,k}=denoise_ecg_wavelet(spare1-mean(spare1), Fs,'sym4',9);
                newData.(map).(sub).spare2_trace{:,k}=denoise_ecg_wavelet(spare2-mean(spare2), Fs, 'sym4',9);
                newData.(map).(sub).spare3_trace{:,k}=denoise_ecg_wavelet(spare3-mean(spare3), Fs, 'sym4',9);
            end
            FP=sub_align_data.(map).(sub).FP_position_rov{:,k};
            RP_pos=round(RP*Fc); % conversion from sec to points
            newData.(map).(sub).rov_trace{:,k}=align_rov_traces(FP,RP_pos,rov);

        end
    end
end


end
