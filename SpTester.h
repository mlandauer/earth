// $Id$ 

class SpTester
{
	public:
		SpTester(string className);
		static void finish();
		static void setVerbose(bool v) { verbose = v; };
		static void setFloatDelta(float d) { floatDelta = d; };
		static float getFloatDelta() { return floatDelta; };
		virtual void test() = 0;
	protected:
		bool checkEqual(string testName, string a, string b);
		bool checkEqual(string testName, int a, int b);
		bool checkEqualBool(string testName, bool a, bool b);
		bool checkEqual(string testName, float a, float b);
		bool checkEqual(string testName, float a, float b, float delta);
		bool check(string testName, bool a);
		bool checkNULL(string testName, void *p);
		bool checkNotNULL(string testName, void *p);
	private:
		static bool verbose;
		static int noFails, noSuccesses;
		static float floatDelta;
		string name;
		string toString(int a);
		string toStringBool(bool a);
		string toString(float a);
		bool check(string testName, bool a, string expected, string got);
		void failMessage(string testName, string expected, string got);
		void successMessage(string testName, string message);
};

