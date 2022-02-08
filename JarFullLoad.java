import java.lang.Class;
import java.net.URLClassLoader;
import java.net.URL;
import java.net.MalformedURLException;
import java.io.IOException;
import java.io.File;
import java.util.jar.JarFile;
import java.util.zip.CRC32;
import java.util.jar.JarEntry;
import java.util.Set;
import java.util.HashSet;
import java.util.Enumeration;
import java.util.zip.CRC32;

// import sun.misc.URLClassPath;
// import sun.misc.Resource;

// import java.io.FileWriter;
// import java.io.BufferedWriter;

public class JarFullLoad {
    public static Set<String> getClassNamesFromJarFile(String jarName) throws IOException {
        File givenFile = new File(jarName);
        Set<String> classNames = new HashSet<>();
        try (JarFile jarFile = new JarFile(givenFile)) {
            Enumeration<JarEntry> e = jarFile.entries();
            while (e.hasMoreElements()) {
                JarEntry jarEntry = e.nextElement();
                if (jarEntry.getName().endsWith(".class")) {
                    String className = jarEntry.getName()
                        .replace("/", ".")
                        .replace(".class", "");
                    if (!className.startsWith("com.sun.org.apache.bcel.internalfile")) {
                        classNames.add(className);
                    }
                }
            }
            return classNames;
        }
    }
    public static void main(String[] args) {
        // jconsole
        String jarName = System.getProperty("user.dir") + '/' + "guava-31.0.1-jre.jar";
        System.out.println(jarName);
        String[] classNames;
        URLClassLoader cld;
        try {
            classNames = getClassNamesFromJarFile(jarName).toArray(new String[0]);
            URL url = new URL("file", "", jarName);
            URL[] urls = new URL[1];
            urls[0] = url;
            cld = new URLClassLoader(urls);
        } catch (Exception e) {
            System.out.println("!smth wrong! " + e);
            return;
        }
        
        try {
            // BufferedWriter writer = new BufferedWriter(new FileWriter("rt-classes.txt"));

            // URLClassPath ucp = new URLClassPath(urls);
            for (String name : classNames) {
                Class cls = cld.loadClass(name);
                // System.out.println(name);
            }
            System.out.println("finish");
            // Class cls = cld.loadClass(classNames[0]);

            // writer.close();
        }  catch (Exception e) {
            System.out.println(e);
            return;
        }
    }
}