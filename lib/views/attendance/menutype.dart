
enum MenuItemType { ApplyRegularization, ApplyLeave }

getMenuItemString(MenuItemType menuItemType) {
  switch (menuItemType) {
    case MenuItemType.ApplyRegularization:
      return "Apply Bulk Regularization";
    case MenuItemType.ApplyLeave:
      return "Apply Leave";
  }
}

enum SingleMenuItemType { AttendanceLog }

getOneMenuString(SingleMenuItemType menuItemType) {
  switch (menuItemType) {
    case SingleMenuItemType.AttendanceLog:
      return "Attendance Log";
  }
}
