import numpy as np
def drop_one_sub(sub, whole_df,fig_final_folder,addition_title_plots):
    
    # handling drop of the subject
    whole_df_no_sub=whole_df[whole_df['id']!=sub]
    
    # signlas and y_true of the new df
    y_true=np.array(whole_df_no_sub['class'])
    signals=whole_df_no_sub.drop(['class','id'],axis=1)
    
    fig_final_folder=f"/sub_{sub}_dropped" +fig_final_folder 
    addition_title_plots=addition_title_plots+f", sub {sub} dropped"
    
    return whole_df_no_sub,y_true,signals,fig_final_folder,addition_title_plots
    