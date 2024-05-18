ncols = 5

folder = "/home/rgalafassi/Documents/Phd/Experiments/Carbon/Nanotubes/Raman/Saphire_collaps/21-09-03_NanotubesCollapse/Data/2D/"
filename = "2D_P12_open.csv"
filename = folder .. filename



for i=2, ncols do
    s = "@+ < '"..filename..":1:"..i.."::' _ decimal_comma"
    F:execute(s)
    --renaming not completed
    --n = F:get_dataset_count()
    --s = "@" ..n..": title"
end
