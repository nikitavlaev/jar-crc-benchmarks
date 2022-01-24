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
import java.nio.ByteBuffer;
import java.io.ByteArrayOutputStream;
import java.security.ProtectionDomain;
import java.io.ObjectStreamClass;

public class FakeBC {
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

    private static void action(String[] args, ByteBuffer bbuf, URLClassLoader cld) {
        try {
            Class cl = cld.myDefineClass(args[0], bbuf, null);
            System.out.println(cl);
        } catch (java.lang.ClassNotFoundException e) {
            System.out.println(e);
        } catch (java.io.IOException e) {
            System.out.println(e);
        }
    }
    public static void main(String[] args) {

        // ProtectionDomain domain = ObjectStreamClass.getClass().getProtectionDomain();

        String jarName = System.getProperty("user.dir") + '/' + "rt.jar";
        System.out.println(jarName + args[0] + args[1]);
        String[] classNames;
        URLClassLoader cld;
        try {
            classNames = getClassNamesFromJarFile(jarName).toArray(new String[0]);
            URL url = new URL("file", "", jarName);
            URL[] urls = new URL[1];
            urls[0] = url;
            
            // hash 1102067511 sun/security/krb5/Credentials$1.class 
            // 1069973286 JarFullLoad
            // 210767841 FakeBC
            int crc32 = Integer.parseInt(args[1]);
            int bc_len = Integer.parseInt(args[2]);
            cld = new URLClassLoader(urls);
            byte[] header = "1234".getBytes();
            byte[] crc32_bytes = ByteBuffer.allocate(4).putInt(crc32).array();
            byte[] bc_len_bytes = ByteBuffer.allocate(4).putInt(bc_len).array();
            // byte [] crc32_bytes = "5678".getBytes();
            
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream( );
            outputStream.write(header);
            outputStream.write(crc32_bytes);
            outputStream.write(bc_len_bytes);

            byte buf[] = outputStream.toByteArray();

            ByteBuffer bbuf = ByteBuffer.wrap(buf);
            // System.out.println(cld.defineClass("Fake", buf, null));
            // System.out.println(cld.myDefineClass(buf, 0, buf.length));
            // if (args[0].equals("0")) {
            //     System.out.println("SKIP");
            //     return;
            // }
            action(args, bbuf, cld);
            
        } catch (Exception e) {
            System.out.println("!smth wrong! " + e);
            return;
        }

        // try {
        //     byte[] rbuf = "1234".getBytes();
        //     ByteBuffer buf = ByteBuffer.wrap(rbuf);
        //     System.out.println(cld.defineClass("Fake", buf, ));
        //     // String[] classNames = getClassNamesFromJarFile(jarName).toArray(new String[0]);
        //     // JarFile jar = new JarFile(jarName);
        //     // for (String name : classNames) {   
        //     //     JarEntry entry = jar.getJarEntry(name);
        //     //     System.out.println("hash " + entry.getCrc());
        //     // }

        //     // URLClassLoader cld = new URLClassLoader(urls);
        //     // System.out.println("cld " + cld);
            
        //     // Class cls = cld.loadClass(classNames[0]);
        //     // System.out.println("class " + cls);


            
        // } catch (Exception e) {
        //     System.out.println("!smth wrong! " + e);
        //     return;
        // }
    }
}
