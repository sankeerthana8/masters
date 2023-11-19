import java.util.Scanner;

public class Algos {


    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        long n = sc.nextInt();
        long[] arr = new long[(int) n];
        for (int i = 0; i < n; i++) {
            arr[i] = sc.nextLong();
        }
        long length = arr.length;
        System.out.println(numberOfInversions(arr, length));
    }
    static long  inversion_count = 0;
    public static long numberOfInversions(long[] arr, long n) {
        long[] ansList = new long[(int)n];

        sort(arr, ansList, 0, arr.length - 1);
        return inversion_count;
    }

    public static void sort(long[] arr, long[] ansList, int low, int high) {
        if (low < high) {
            int mid = low+(high-low) / 2;
            sort(arr, ansList, low, mid);
            sort(arr, ansList, mid + 1, high);
            merge(arr, ansList, low, mid+1, high);
        }

    }

    public static long merge(long[] arr, long[] ansList, int low, int mid, int high) {
        int i, j, k;

        i = low;
        j = mid;
        k = low;

        long count =0;
        while ((i <= mid - 1) && (j <= high)) {
            if (arr[i] <= arr[j]) {
                ansList[k++] = arr[i++];
            } else {
                ansList[k++] = arr[j++];
                inversion_count += mid-i;
            }
        }
        while (i <= mid - 1)
            ansList[k++] = arr[i++];
        while (j <= high)
            ansList[k++] = arr[j++];
        for (i = low; i <= high; i++)
            arr[i] = ansList[i];

        return count;
    }
}