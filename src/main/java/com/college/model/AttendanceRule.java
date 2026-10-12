package com.college.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class AttendanceRule implements Serializable {
    private static final long serialVersionUID = 1L;

    private int ruleId;
    private String ruleName;
    private double minimumPercentage;
    private double warningThreshold;
    private double criticalThreshold;
    private boolean active;
    private Timestamp updatedAt;

    public AttendanceRule() {}

    public AttendanceRule(int ruleId, String ruleName, double minimumPercentage, double warningThreshold, double criticalThreshold, boolean active) {
        this.ruleId = ruleId;
        this.ruleName = ruleName;
        this.minimumPercentage = minimumPercentage;
        this.warningThreshold = warningThreshold;
        this.criticalThreshold = criticalThreshold;
        this.active = active;
    }

    public int getRuleId() { return ruleId; }
    public void setRuleId(int ruleId) { this.ruleId = ruleId; }

    public String getRuleName() { return ruleName; }
    public void setRuleName(String ruleName) { this.ruleName = ruleName; }

    public double getMinimumPercentage() { return minimumPercentage; }
    public void setMinimumPercentage(double minimumPercentage) { this.minimumPercentage = minimumPercentage; }

    public double getWarningThreshold() { return warningThreshold; }
    public void setWarningThreshold(double warningThreshold) { this.warningThreshold = warningThreshold; }

    public double getCriticalThreshold() { return criticalThreshold; }
    public void setCriticalThreshold(double criticalThreshold) { this.criticalThreshold = criticalThreshold; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
