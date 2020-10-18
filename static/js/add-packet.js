function addPacket() {
    let newRow = document.getElementById("js-template-row").cloneNode(true);
    newRow.removeAttribute("style");
    newRow.removeAttribute("id");
    let table = document.getElementById("js-table-seed-edit");
    table.append(newRow);
}
