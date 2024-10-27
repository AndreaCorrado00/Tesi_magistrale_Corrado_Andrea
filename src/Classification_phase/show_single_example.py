def show_single_example(data,Fs, idx,title_plot):
    
    import numpy as np
    import matplotlib.pyplot as plt
    example=np.array(data.iloc[idx])
    
    t=np.arange(0,len(example)/Fs,1/Fs)
    
    plt.figure()
    plt.plot(t,example)
    plt.title(title_plot)
    plt.xlabel("Time [s]")
    plt.ylabel("[mV]")
    plt.xlim(0,1)
    plt.xticks(np.arange(0,1,0.1))
    plt.tight_layout()
