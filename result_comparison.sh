#!/bin/bash

# Define the path to the results CSV file and report directory
REPORT_DIR="/home/akpos/week5/my-git-repo/reports"
RESULTS_FILE="$REPORT_DIR/baseline_model_results.csv"
REPORT_FILE="$REPORT_DIR/baseline_model_report.md"

# Check if the baseline results file exists
if [[ ! -f "$RESULTS_FILE" ]]; then
    echo "Error: baseline_model_results.csv not found in the report directory."
    exit 1
fi

# Identify the best model by highest F1-score (assumed to be in the 5th column)
best_model=$(sort -t, -k5 -rg "$RESULTS_FILE" | head -n 1)

# Extract necessary details from the best model line
data_version=$(echo "$best_model" | awk -F ',' '{print $1}')
model_name=$(echo "$best_model" | awk -F ',' '{print $2}')
precision=$(echo "$best_model" | awk -F ',' '{print $3}')
recall=$(echo "$best_model" | awk -F ',' '{print $4}')
f1_score=$(echo "$best_model" | awk -F ',' '{print $5}')
roc_auc=$(echo "$best_model" | awk -F ',' '{print $6}')



# Define path for confusion matrix image
confusion_matrix_file="/home/akpos/week5/my-git-repo/reports/datav1.5_RandomForestClassifier_confusion_matrix.png"

# Generate the Markdown report
cat <<EOF > "$REPORT_FILE"
# Baseline Model Evaluation
## Model Information
* **Model Name**: $model_name
* **Data Version**: $data_version
## Performance Metrics
* **F1-Score**: $f1_score
* **Recall**: $recall
* **Precision**: $precision
* **ROC-AUC**: $roc_auc
## Confusion Matrix
![Confusion Matrix Image](${confusion_matrix_file})
EOF

echo "Report generated: $REPORT_FILE"