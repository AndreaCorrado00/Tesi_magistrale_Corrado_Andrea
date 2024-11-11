import matplotlib.pyplot as plt


def draw_his_boundaries(atr_t,ven_t, th_his=None,disp_atr_vent_boxes=False):
    
    
    if th_his is not None and not(disp_atr_vent_boxes):
        plt.plot([atr_t, ven_t], [th_his, th_his], color='red', linestyle='--')
        plt.plot([atr_t, ven_t], [-th_his, -th_his], color='red', linestyle='--')
        plt.plot([atr_t, atr_t], [th_his, -th_his],color='grey', linestyle=':');
        plt.plot([ven_t, ven_t], [th_his, -th_his],color='grey', linestyle=':');
        
    elif th_his is not None and disp_atr_vent_boxes:
        y_min, y_max = plt.gcf().gca().get_ylim()
        plt.plot([atr_t, ven_t], [th_his, th_his], color='red', linestyle='--')
        plt.plot([atr_t, ven_t], [-th_his, -th_his], color='red', linestyle='--')
        plt.plot([atr_t, atr_t], [th_his, -th_his],color='grey', linestyle=':');
        plt.plot([ven_t, ven_t], [th_his, -th_his],color='grey', linestyle=':');
    
        
        # plt.fill_between([0, atr_t], 0.5,max(0.6,y_max) , color=(0.8, 0.9, 1.0), alpha=0.3)  # Azzurro chiaro
        # plt.fill_between([0, atr_t], -0.5, min(-0.6,y_min), color=(0.8, 0.9, 1.0), alpha=0.3)  # Azzurro chiaro
        
        # Riempimento tra le due linee blu (tratteggiata e puntinata)
        plt.fill_between([0, atr_t], 0.3, 0, color=(0.7, 1.0, 0.7), alpha=0.3)  # Verde chiaro
        plt.fill_between([0, atr_t], -0.3, 0, color=(0.7, 1.0, 0.7), alpha=0.3)  # Verde chiaro

    else:
        plt.axvline(x=atr_t,color='grey', linestyle=':')
        plt.axvline(x=ven_t,color='grey', linestyle=':')