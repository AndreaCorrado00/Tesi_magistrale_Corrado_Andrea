def draw_his_boundaries(atr_t,ven_t, th_his=None):
    import matplotlib.pyplot as plt
    
    if th_his is not None:
        plt.plot([atr_t, ven_t], [th_his, th_his], color='red', linestyle='--')
        plt.plot([atr_t, ven_t], [-th_his, -th_his], color='red', linestyle='--')
        plt.plot([atr_t, atr_t], [th_his, -th_his],color='grey', linestyle=':');
        plt.plot([ven_t, ven_t], [th_his, -th_his],color='grey', linestyle=':');
        
    else:
        plt.axvline(x=atr_t,color='grey', linestyle=':')
        plt.axvline(x=ven_t,color='grey', linestyle=':')