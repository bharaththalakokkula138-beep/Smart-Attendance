package com.college.model;

import java.io.Serializable;

public class LeavePredictionResult implements Serializable {
    private static final long serialVersionUID = 1L;

    private int subjectId;
    private String subjectName;
    private int currentAttended;
    private int currentConducted;
    private double currentPercentage;
    private int upcomingClasses;
    private int classesToMiss;
    private int predictedAttended;
    private int predictedConducted;
    private double predictedPercentage;
    private double requiredPercentage;
    private boolean safe;
    private String status; // SAFE, WARNING, CRITICAL
    private String badgeClass;
    private String message;
    private String recommendation;

    public LeavePredictionResult() {}

    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public int getCurrentAttended() { return currentAttended; }
    public void setCurrentAttended(int currentAttended) { this.currentAttended = currentAttended; }

    public int getCurrentConducted() { return currentConducted; }
    public void setCurrentConducted(int currentConducted) { this.currentConducted = currentConducted; }

    public double getCurrentPercentage() { return currentPercentage; }
    public void setCurrentPercentage(double currentPercentage) { this.currentPercentage = currentPercentage; }

    public int getUpcomingClasses() { return upcomingClasses; }
    public void setUpcomingClasses(int upcomingClasses) { this.upcomingClasses = upcomingClasses; }

    public int getClassesToMiss() { return classesToMiss; }
    public void setClassesToMiss(int classesToMiss) { this.classesToMiss = classesToMiss; }

    public int getPredictedAttended() { return predictedAttended; }
    public void setPredictedAttended(int predictedAttended) { this.predictedAttended = predictedAttended; }

    public int getPredictedConducted() { return predictedConducted; }
    public void setPredictedConducted(int predictedConducted) { this.predictedConducted = predictedConducted; }

    public double getPredictedPercentage() { return predictedPercentage; }
    public void setPredictedPercentage(double predictedPercentage) { this.predictedPercentage = predictedPercentage; }

    public double getRequiredPercentage() { return requiredPercentage; }
    public void setRequiredPercentage(double requiredPercentage) { this.requiredPercentage = requiredPercentage; }

    public boolean isSafe() { return safe; }
    public void setSafe(boolean safe) { this.safe = safe; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getBadgeClass() { return badgeClass; }
    public void setBadgeClass(String badgeClass) { this.badgeClass = badgeClass; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getRecommendation() { return recommendation; }
    public void setRecommendation(String recommendation) { this.recommendation = recommendation; }
}
