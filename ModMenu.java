import javax.swing.*;
import java.awt.*;
import java.util.Timer;
import java.util.TimerTask;

public class GameWithModMenu {

    // Simulated player class
    static class Player {
        int health = 100;
        boolean canCollide = true;
        float velocityY = 0.0f;

        void update() {
            // Check mod toggles
            if (ModMenu.godMode) {
                health = 9999;
            }

            if (ModMenu.fly) {
                velocityY = 1.0f;
            } else {
                velocityY = -9.8f; // gravity
            }

            if (ModMenu.noclip) {
                canCollide = false;
            } else {
                canCollide = true;
            }

            // Print current state (for demo)
            System.out.println("Health: " + health + ", VelocityY: " + velocityY + ", Collisions: " + canCollide);
        }
    }

    // Mod Menu class
    static class ModMenu {
        public static boolean godMode = false;
        public static boolean fly = false;
        public static boolean noclip = false;

        public static void createMenu() {
            JFrame frame = new JFrame("Mod Menu");
            frame.setSize(300, 200);
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setAlwaysOnTop(true);

            JPanel panel = new JPanel();
            panel.setLayout(new GridLayout(3, 1));

            JCheckBox godModeBox = new JCheckBox("God Mode");
            JCheckBox flyBox = new JCheckBox("Fly");
            JCheckBox noclipBox = new JCheckBox("No Clip");

            godModeBox.addActionListener(e -> godMode = godModeBox.isSelected());
            flyBox.addActionListener(e -> fly = flyBox.isSelected());
            noclipBox.addActionListener(e -> noclip = noclipBox.isSelected());

            panel.add(godModeBox);
            panel.add(flyBox);
            panel.add(noclipBox);

            frame.add(panel);
            frame.setLocationRelativeTo(null);
            frame.setVisible(true);
        }
    }

    // Main Game Loop
    public static void main(String[] args) {
        Player player = new Player();
        ModMenu.createMenu();

        Timer timer = new Timer();
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                player.update();
            }
        }, 0, 1000); // update every second
    }
}
