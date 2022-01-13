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

import sun.misc.URLClassPath;
import sun.misc.Resource;

public class JarCrcEntry {
    public static Set<String> getClassNamesFromJarFile(String jarName) throws IOException {
        File givenFile = new File(jarName);
        Set<String> classNames = new HashSet<>();
        try (JarFile jarFile = new JarFile(givenFile)) {
            Enumeration<JarEntry> e = jarFile.entries();
            while (e.hasMoreElements()) {
                JarEntry jarEntry = e.nextElement();
                if (jarEntry.getName().endsWith(".class")) {
                    String className = jarEntry.getName();
                    //  .replace("/", ".");
                    //  .replace(".class", "");
                    classNames.add(className);
                }
            }
            return classNames;
        }
    }
    public static void main(String[] args) {
        // jconsole
        String jarName = System.getProperty("user.dir") + '/' + "rt.jar";
        System.out.println(jarName);

        try {
            String[] classNames = getClassNamesFromJarFile(jarName).toArray(new String[0]);
            JarFile jar = new JarFile(jarName);
            for (String name : classNames) {   
                JarEntry entry = jar.getJarEntry(name);
                System.out.println("hash " + entry.getCrc());
            }

            // URLClassLoader cld = new URLClassLoader(urls);
            // System.out.println("cld " + cld);
            
            // Class cls = cld.loadClass(classNames[0]);
            // System.out.println("class " + cls);


            
        } catch (Exception e) {
            System.out.println("!smth wrong! " + e);
            return;
        }
    }
}
