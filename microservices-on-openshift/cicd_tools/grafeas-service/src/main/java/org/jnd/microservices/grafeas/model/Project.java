package org.jnd.microservices.grafeas.model;

public class Project {

    private String name = null;

    public Project() {
    }

    public Project(String name) {
        this.name = name;
    }

    public String getName() {
        if (!name.startsWith("projects/"))
            return "projects/"+name;
        else
            return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
