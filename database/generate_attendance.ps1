# Generate comprehensive attendance dataset for semester
$outputFile = "c:\TT-PROJECT\database\attendance_data.sql"
$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine("-- Attendance Records for Semester (Aug 01, 2026 to Oct 06, 2026)")
[void]$sb.AppendLine("INSERT INTO attendance (student_id, subject_id, date, status, marked_by) VALUES")

# 40 class dates between Aug 01 and Oct 05, skipping weekends
$dates = @()
$curr = [DateTime]::Parse("2026-08-03")
while ($dates.Count -lt 40) {
    if ($curr.DayOfWeek -ne [DayOfWeek]::Saturday -and $curr.DayOfWeek -ne [DayOfWeek]::Sunday) {
        $dates += $curr.ToString("yyyy-MM-dd")
    }
    $curr = $curr.AddDays(1)
}

# CSE Students: 1 to 15, CSE Subjects: 1, 2, 3, 4, 5
# Bharath is student_id 1
# Target attendance counts for Bharath:
# Subject 1 (DBMS): 33/40 (82.5%)
# Subject 2 (AIML): 31/40 (77.5%)
# Subject 3 (ADA): 29/40 (72.5%)
# Subject 4 (OS): 27/40 (67.5%)
# Subject 5 (JAVA): 35/40 (87.5%)

$studentTargets = @{
    1 = @(33, 31, 29, 27, 35) # Bharath (Overall 77.5% - Safe overall, warning/critical in ADA/OS)
    2 = @(36, 37, 35, 36, 38) # Aarav Patel (~91% Safe)
    3 = @(38, 37, 38, 36, 39) # Ananya Sharma (~94% Safe)
    4 = @(34, 35, 33, 34, 36) # Rohan Gupta (~86% Safe)
    5 = @(32, 33, 32, 31, 34) # Sneha Reddy (~81% Safe)
    6 = @(31, 30, 31, 30, 32) # Vikram Singh (~77% Safe)
    7 = @(32, 31, 30, 32, 33) # Divya Joshi (~79% Safe)
    8 = @(29, 30, 28, 29, 30) # Rahul Nair (~73% Warning)
    9 = @(28, 29, 27, 28, 30) # Pooja Iyer (~71% Warning)
    10 = @(30, 29, 29, 30, 31) # Karthik Rao (~74.5% Warning)
    11 = @(25, 24, 26, 23, 26) # Neha Kulkarni (~62% Critical)
    12 = @(23, 22, 24, 21, 25) # Aditya Deshmukh (~57.5% Critical)
    13 = @(26, 25, 24, 25, 27) # Meera Pillai (~63.5% Critical)
    14 = @(35, 34, 35, 33, 36) # Varun Verma (~86.5% Safe)
    15 = @(24, 23, 25, 22, 26) # Kavya Menon (~60% Critical)
}

$first = $true
$facultyMap = @{ 1 = 1; 2 = 2; 3 = 1; 4 = 2; 5 = 3; 6 = 4; 7 = 3; 8 = 5 }

foreach ($sId in 1..15) {
    $targets = $studentTargets[$sId]
    for ($subjIdx = 0; $subjIdx -lt 5; $subjIdx++) {
        $subjId = $subjIdx + 1
        $targetPresent = $targets[$subjIdx]
        $markedBy = $facultyMap[$subjId]

        # Select which dates are present vs absent
        # For realistic trend, distribute absences more heavily in recent weeks for students in warning/critical
        $rand = [System.Random]::new($sId * 100 + $subjId)
        $indices = 0..39 | Sort-Object { $rand.Next() }
        $presentIndices = [System.Collections.Generic.HashSet[int]]::new()
        for ($k = 0; $k -lt $targetPresent; $k++) {
            [void]$presentIndices.Add($indices[$k])
        }

        for ($d = 0; $d -lt 40; $d++) {
            $status = if ($presentIndices.Contains($d)) { "'PRESENT'" } else { "'ABSENT'" }
            $dt = $dates[$d]
            if (-not $first) {
                [void]$sb.Append(",`n")
            }
            $sb.Append("($sId, $subjId, '$dt', $status, $markedBy)")
            $first = $false
        }
    }
}

# ISE Students: 16, 17, 18, ISE Subjects: 6, 7
$iseTargets = @{
    16 = @(34, 35) # Tanvi Bhat (~86% Safe)
    17 = @(29, 28) # Nikhil Shenoy (~71% Warning)
    18 = @(24, 25) # Ritu Hegde (~61% Critical)
}
foreach ($sId in 16..18) {
    $targets = $iseTargets[$sId]
    for ($subjIdx = 0; $subjIdx -lt 2; $subjIdx++) {
        $subjId = $subjIdx + 6
        $targetPresent = $targets[$subjIdx]
        $markedBy = $facultyMap[$subjId]
        $rand = [System.Random]::new($sId * 100 + $subjId)
        $indices = 0..39 | Sort-Object { $rand.Next() }
        $presentIndices = [System.Collections.Generic.HashSet[int]]::new()
        for ($k = 0; $k -lt $targetPresent; $k++) {
            [void]$presentIndices.Add($indices[$k])
        }
        for ($d = 0; $d -lt 40; $d++) {
            $status = if ($presentIndices.Contains($d)) { "'PRESENT'" } else { "'ABSENT'" }
            $dt = $dates[$d]
            if (-not $first) {
                [void]$sb.Append(",`n")
            }
            $sb.Append("($sId, $subjId, '$dt', $status, $markedBy)")
            $first = $false
        }
    }
}

# ECE Students: 19, 20, ECE Subject: 8
$eceTargets = @{
    19 = 33 # Arjun Nambiar (82.5% Safe)
    20 = 28 # Swati Kamat (70% Warning)
}
foreach ($sId in 19..20) {
    $targetPresent = $eceTargets[$sId]
    $subjId = 8
    $markedBy = $facultyMap[$subjId]
    $rand = [System.Random]::new($sId * 100 + $subjId)
    $indices = 0..39 | Sort-Object { $rand.Next() }
    $presentIndices = [System.Collections.Generic.HashSet[int]]::new()
    for ($k = 0; $k -lt $targetPresent; $k++) {
        [void]$presentIndices.Add($indices[$k])
    }
    for ($d = 0; $d -lt 40; $d++) {
        $status = if ($presentIndices.Contains($d)) { "'PRESENT'" } else { "'ABSENT'" }
        $dt = $dates[$d]
        if (-not $first) {
            [void]$sb.Append(",`n")
        }
        $sb.Append("($sId, $subjId, '$dt', $status, $markedBy)")
        $first = $false
    }
}

[void]$sb.AppendLine(";")
[System.IO.File]::WriteAllText($outputFile, $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Output "Generated attendance SQL with $(3000 + 240 + 80) rows at $outputFile"
