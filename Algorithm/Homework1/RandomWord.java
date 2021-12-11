import edu.princeton.cs.algs4.StdIn;
import edu.princeton.cs.algs4.StdOut;
import edu.princeton.cs.algs4.StdRandom;

public class RandomWord {
    public static void main(String[] args) {
        double test = 0;
        String champion = "initia";
        while (!StdIn.isEmpty()) {
            test++;
            String string1 = StdIn.readString();
            double p = 1.0 / test;
            if (StdRandom.bernoulli(p)) {
                champion = string1;
            }
        }
        StdOut.println(champion);
    }
}