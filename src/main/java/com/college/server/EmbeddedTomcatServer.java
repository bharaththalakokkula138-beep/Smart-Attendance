package com.college.server;

import java.io.File;

import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

public class EmbeddedTomcatServer {

    public static void main(String[] args) throws Exception {

        String portEnv = System.getenv("PORT");
        int port = (portEnv != null && !portEnv.isEmpty())
                ? Integer.parseInt(portEnv)
                : 8085;

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        tomcat.setBaseDir("target/tomcat");

        // Listen on all network interfaces
        tomcat.getConnector().setProperty("address", "0.0.0.0");

        File webappDir = new File("src/main/webapp");
        if (!webappDir.exists()) {
            webappDir.mkdirs();
        }

        String docBase = webappDir.getAbsolutePath();

        StandardContext ctx = (StandardContext) tomcat.addWebapp("", docBase);
        ctx.setParentClassLoader(
                EmbeddedTomcatServer.class.getClassLoader()
        );

        File classesDir = new File("target/classes");
        if (classesDir.exists()) {
            WebResourceRoot resources = new StandardRoot(ctx);
            resources.addPreResources(
                    new DirResourceSet(
                            resources,
                            "/WEB-INF/classes",
                            classesDir.getAbsolutePath(),
                            "/"
                    )
            );
            ctx.setResources(resources);
        }

        System.out.println("Smart Attendance & Shortage Prediction System");
        System.out.println("Server listening on port: " + port);

        tomcat.start();
        tomcat.getServer().await();
    }
}
