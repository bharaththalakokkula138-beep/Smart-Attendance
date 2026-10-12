package com.college.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class RiskPrediction implements Serializable {
    private static final long serialVersionUID = 1L;

    private String riskLevel; // LOW, MEDIUM, HIGH
    private String riskBadgeClass;
    private String riskColor;
    private double currentPercentage;
    private double requiredPercentage;
    private int classesConducted;
    private int classesAttended;
    private int absences;
    private int estimatedRemainingClasses;
    private double maxPossiblePercentage;
    private double recentAbsenceRate;
    private int consecutiveClassesNeeded;
    private List<String> reasons = new ArrayList<>();
    private String recommendation;

    public RiskPrediction() {}

    public String getRiskLevel() { return riskLevel; }
    public void setRiskLevel(String riskLevel) { this.riskLevel = riskLevel; }

    public String getRiskBadgeClass() { return riskBadgeClass; }
    public void setRiskBadgeClass(String riskBadgeClass) { this.riskBadgeClass = riskBadgeClass; }

    public String getRiskColor() { return riskColor; }
    public void setRiskColor(String riskColor) { this.riskColor = riskColor; }

    public double getCurrentPercentage() { return currentPercentage; }
    public void setCurrentPercentage(double currentPercentage) { this.currentPercentage = currentPercentage; }

    public double getRequiredPercentage() { return requiredPercentage; }
    public void setRequiredPercentage(double requiredPercentage) { this.requiredPercentage = requiredPercentage; }

    public int getClassesConducted() { return classesConducted; }
    public void setClassesConducted(int classesConducted) { this.classesConducted = classesConducted; }

    public int getClassesAttended() { return classesAttended; }
    public void setClassesAttended(int classesAttended) { this.classesAttended = classesAttended; }

    public int getAbsences() { return absences; }
    public void setAbsences(int absences) { this.absences = absences; }

    public int getEstimatedRemainingClasses() { return estimatedRemainingClasses; }
    public void setEstimatedRemainingClasses(int estimatedRemainingClasses) { this.estimatedRemainingClasses = estimatedRemainingClasses; }

    public double getMaxPossiblePercentage() { return maxPossiblePercentage; }
    public void setMaxPossiblePercentage(double maxPossiblePercentage) { this.maxPossiblePercentage = maxPossiblePercentage; }

    public double getRecentAbsenceRate() { return recentAbsenceRate; }
    public void setRecentAbsenceRate(double recentAbsenceRate) { this.recentAbsenceRate = recentAbsenceRate; }

    public int getConsecutiveClassesNeeded() { return consecutiveClassesNeeded; }
    public void setConsecutiveClassesNeeded(int consecutiveClassesNeeded) { this.consecutiveClassesNeeded = consecutiveClassesNeeded; }

    public List<String> getReasons() { return reasons; }
    public void setReasons(List<String> reasons) { this.reasons = reasons; }
    public void addReason(String reason) { this.reasons.add(reason); }

    public String getRecommendation() { return recommendation; }
    public void setRecommendation(String recommendation) { this.recommendation = recommendation; }
}
