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

#Define image file part for confusion matrix based on data version and model name
confusion_matrix_file="reports/${data_version}_${model_name}_confusion_matrix.png"

# Generate the Markdown report
{
    echo "# Baseline Model Report"
    echo "## Best Model Summary"
    echo "- **Data Version**: $data_version"
    echo "- **Model Name**: $model_name"
    echo "## Metrics"
    echo "- **F1 Score**: $f1_score"
    echo "- **Recall**: $recall"
    echo "- **Precision**: $precision"
    echo "- **ROC_AUC**: $roc_auc"
    echo "- **Confusion Matrix**:"
   echo "![Confusion Matrix](reports/$confusion_matrix_file)"
} > "$REPORT_FILE"

echo "Report generated: $REPORT_FILE"
