#include<bits/stdc++.h>
using namespace std;


typedef pair<int, int> iPair;


struct Graph
{
        int V, E;
        vector< pair<int, iPair> > edges;


        Graph(int V, int E)
        {
                this->V = V;
                this->E = E;
        }


        void additonOfEdge(int u, int v, int w)
        {
                edges.push_back({w, {u, v}});
        }


        int minimum_mst_value();

        void printMSTEdge();
};


struct setWhichDisjoint
{
        int *root, *rank;
        int n;


        setWhichDisjoint(int n)
        {

                this->n = n;
                root = new int[n+1];
                rank = new int[n+1];

                int i;
                for ( i= 0; i <= n; i++)
                {
                        rank[i] = 0;


                        root[i] = i;
                }
        }

        int search(int u)
        {

                if (u != root[u])
                        root[u] = search(root[u]);
                return root[u];
        }


        void mix2set(int x, int y)
        {
                x = search(x), y = search(y);


                if (rank[x] > rank[y])
                        root[y] = x;
                else
                        root[x] = y;

                if (rank[x] == rank[y])
                        rank[y]++;
        }
};



int Graph::minimum_mst_value()
{
        int sum = 0;


        sort(edges.begin(), edges.end());


        setWhichDisjoint ds(V);


        vector< pair<int, iPair> >::iterator it;
        
        for (it=edges.begin(); it!=edges.end(); it++)
        {
                int u = it->second.first;
                int v = it->second.second;

                int a = ds.search(u);
                int b = ds.search(v);

                if (a != b)
                {

                        sum += it->first;
                        ds.mix2set(a, b);
                }
        }

        return sum;
}

void Graph::printMSTEdge()
{
        int sum = 0;


        sort(edges.begin(), edges.end());


        setWhichDisjoint ds(V);


        vector< pair<int, iPair> >::iterator it;
        // for (it=edges.begin(); it!=edges.end(); it++)
        // {
        //         int u = it->second.first;
        //         int v = it->second.second;

        //         int a = ds.search(u);
        //         int b = ds.search(v);


        //         if (a != b)
        //         {
        //                 cout << u << " " << v << endl;
        //                 sum += it->first;
        //                 ds.mix2set(a, b);
        //         }
        // }


}


int main()
{

        int vertex , edge ;
        cin>>vertex>>edge;
    Graph g(vertex,edge);
        int s[edge],d[edge],c[edge];
        for(int i=0;i<edge;i++)
        {
            cin>>s[i]>>d[i]>>c[i];
            g.additonOfEdge(s[i], d[i], c[i]);

        }
        // cout<<endl<<endl;
        int sum = g.minimum_mst_value();
        cout<< sum<<endl;
        g.printMSTEdge();

        return 0;
}