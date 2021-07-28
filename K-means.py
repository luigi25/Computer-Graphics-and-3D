import os
import numpy as np
from scipy.io import loadmat
from sklearn.cluster import KMeans
from tkinter import Tcl
import pylab
import tsne


def main():
    bs = []
    names = []
    # import modFinal
    directory = "modFinal/l2_points/FRGC/"
    # directory = "modFinal/l3_points/FRGC/"

    filelist = os.listdir(directory)
    filelist = Tcl().call('lsort', '-dict', filelist)
    for i in range(len(filelist)):
        load = loadmat(str(directory) + str(filelist[i]))
        bs.append(load['l2_points'])
        # bs.append(load['l3_points'])
        load_name = load['file_name']
        load_name = np.reshape(load_name, -1)
        for name in load_name:
            n = name.replace('data/FRGC_noLm_SLC/nose_dataset_modFinal/', '')  # modFinal
            # n = name.replace('data/FRGC_noLm_SLC/nose_dataset/', '') # modGT
            names.append(n.replace('.txt', ''))
    subj = []
    for i in range(len(bs)):
        # l2_points
        mean = np.mean(bs[i], axis=2)
        subj.append(np.reshape(mean, (-1, 256)))
        # subj.append(np.reshape(bs[i], (-1, 1024))) # l3_points
    subj = np.concatenate(subj, axis=0)

    kmeans = KMeans(n_clusters=5, random_state=0, verbose=True)
    kmeans.fit(subj)

    labels = kmeans.labels_
    clusters = kmeans.cluster_centers_

    # save results FRGC_modFinal
    f = open('l2_points_FRGC_modFinal.txt', 'w')
    # f = open('l3_points_FRGC_modFinal.txt', 'w')
    for i in range(len(labels)):
        print('subj_name = ' + str(names[i]) + ', labels = ' + str(labels[i]))
        f.write('subj_name = ' + str(names[i]) + ', labels = ' + str(labels[i]) + '\n')
        if i < len(labels) - 1:
            if names[i][0:5] != names[i + 1][0:5]:
                print('---------------------------------------')
                f.write('-------------------------------------------\n')
    f.close()

    # save results bosphorus_modFinal
    '''
    f = open('l2_points_bosphorus_modFinal.txt', 'w')
    # f = open('l3_points_bosphorus_modFinal.txt', 'w')
    for i in range(len(labels)):
        print('subj_name = ' + str(names[i]) + ', labels = ' + str(labels[i]))
        f.write('subj_name = ' + str(names[i]) + ', labels = ' + str(labels[i]) + '\n')
        if i < len(labels) - 1:
            if names[i][2:5] != names[i + 1][2:5]:
                print('---------------------------------------')
                f.write('-------------------------------------------\n')
    f.close()
    '''

    # plot clusters in 2D
    my_plot = tsne.tsne(subj, 2, 256, 20.0)  # l2_points features
    # my_plot = tsne.tsne(subj, 2, 1024, 20.0) # l3_points features
    pylab.scatter(my_plot[:, 0], my_plot[:, 1], 20, labels)
    pylab.show()

    cluster = [print('cluster', clusters[i]) for i in range(len(clusters))]
    print('ok')


if __name__ == '__main__':
    main()
