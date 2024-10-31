def show_single_example(data,Fs, idx,title_plot, use_iloc=True):
    
    import numpy as np
    import matplotlib.pyplot as plt
    if use_iloc:
        example=np.array(data.iloc[idx])
    else:
        example=np.array(data.loc[idx])
    
    t=np.arange(0,len(example)/Fs,1/Fs)
    
    plt.figure()
    plt.plot(t,example)
    plt.title(title_plot)
    plt.xlabel("Time [s]")
    plt.ylabel("[mV]")
    plt.xlim(0,1)
    plt.xticks(np.arange(0,1,0.1))
    plt.tight_layout()
