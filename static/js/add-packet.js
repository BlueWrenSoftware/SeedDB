function addPacket() {
    let newRow = document.getElementById("template-row").cloneNode(true);
    newRow.removeAttribute("style");
    newRow.removeAttribute("id");
    let table = document.getElementById("seed-edit-table-body");
    table.append(newRow);
}
