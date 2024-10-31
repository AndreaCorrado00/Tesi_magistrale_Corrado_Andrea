def show_examples(data,Fs, map_A_idx,map_B_idx,map_C_idx):
    
    import numpy as np
    import matplotlib.pyplot as plt
    example_class_A=np.array(data.loc[map_A_idx])
    example_class_B=np.array(data.loc[map_B_idx])
    example_class_C=np.array(data.loc[map_C_idx])
    
    t=np.arange(0,len(example_class_A)/Fs,1/Fs)
    
    plt.figure()
    plt.subplot(3,1,1)
    plt.plot(t,example_class_A,label="Example of map A")
    plt.title('Map A example')
    plt.xlabel("Time [s]")
    plt.ylabel("[mV]")
    plt.xlim(0,1)
    
    plt.subplot(3,1,2)
    plt.plot(t,example_class_B,label="Example of map B")
    plt.title('Map B example')
    plt.xlabel("Time [s]")
    plt.ylabel("[mV]")
    plt.xlim(0,1)
    
    plt.subplot(3,1,3)
    plt.plot(t,example_class_C,label="Example of map C")
    plt.title('Map C example')
    plt.xlabel("Time [s]")
    plt.ylabel("[mV]")
    plt.xlim(0,1)
    
    plt.tight_layout()
