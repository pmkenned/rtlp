#include <iostream>

#include <vector>
#include <map>

class Signal {
    private:
        std::string name;
    public:
        Signal(std::string n) : name(n) {}
};

class Module {
    private:
        std::string name;
        std::vector<Signal> signals;
        std::vector<Module *> insts;

    public:
        Module() {}
        Module(std::string n) : name(n) {}

        void add_signal(std::string s) {
            Signal * sig = new Signal(s);
            signals.push_back(*sig);
        }

        void add_inst(Module * m) {
            insts.push_back(m);
        }
};

class Design {
    private:
        Module * top;
        std::map<std::string, Module *> modules;

    public:
        Design() {}

        void add_module(std::string s) {
            Module * m = new Module(s);
            modules[s] = m;
        }

        void add_inst(std::string parent_key, std::string child_key) {
            Module * parent = modules[parent_key];
            Module * child = modules[child_key];
            parent->add_inst(child);
        }
};

int main(int argc, char * argv[]) {

    Design d;

    d.add_module("Alpha");
    d.add_module("Bravo");

    d.add_inst("Alpha", "Bravo");

}
