package com.college.server;

import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

import java.io.File;

public class EmbeddedTomcatServer {

    public static void main(String[] args) throws Exception {
        int port = 8085;
        String portProp = System.getProperty("server.port");
        if (portProp != null && !portProp.isEmpty()) {
            port = Integer.parseInt(portProp);
        }

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        tomcat.setBaseDir("target/tomcat");
        tomcat.getConnector(); // Initialize default HTTP connector

        File webappDir = new File("src/main/webapp");
        if (!webappDir.exists()) {
            webappDir.mkdirs();
        }
        String docBase = webappDir.getAbsolutePath();

        StandardContext ctx = (StandardContext) tomcat.addWebapp("", docBase);
        ctx.setParentClassLoader(EmbeddedTomcatServer.class.getClassLoader());

        File classesDir = new File("target/classes");
        if (classesDir.exists()) {
            WebResourceRoot resources = new StandardRoot(ctx);
            resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                    classesDir.getAbsolutePath(), "/"));
            ctx.setResources(resources);
        }

        System.out.println("==================================================================");
        System.out.println("  Smart Attendance & Shortage Prediction System");
        System.out.println("  Server URL: http://localhost:" + port);
        System.out.println("  Demo Logins:");
        System.out.println("    Student: 21A01 / student123");
        System.out.println("    Faculty: ramesh@college.edu / faculty123");
        System.out.println("    Admin:   admin / admin123");
        System.out.println("==================================================================");

        tomcat.start();
        tomcat.getServer().await();
    }
}
