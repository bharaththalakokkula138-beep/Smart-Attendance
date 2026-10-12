package com.college.model;

import java.io.Serializable;

public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String name;
    private String email;
    private String role; // "STUDENT", "FACULTY", "ADMIN"
    private String codeOrRoll;

    public User() {}

    public User(int id, String name, String email, String role, String codeOrRoll) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.role = role;
        this.codeOrRoll = codeOrRoll;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getCodeOrRoll() { return codeOrRoll; }
    public void setCodeOrRoll(String codeOrRoll) { this.codeOrRoll = codeOrRoll; }
}
