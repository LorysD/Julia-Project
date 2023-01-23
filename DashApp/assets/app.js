function register_event() {
  let filter_dropdown = document.getElementById("filter-dropdown");
  if(filter_dropdown != null) {
    clearInterval(refreshID);

    const bench_julia = document.getElementById("bench-julia");
    const bench_python = document.getElementById("bench-python");
    const bench_r = document.getElementById("bench-r");

    filter_dropdown.addEventListener("click", (event) => {
      bench_julia.textContent = "";
      bench_python.textContent = "";
      bench_r.textContent = "";
    });
  }
}

// call this function every 250 ms
const refreshID = setInterval(register_event, 250);
